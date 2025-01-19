#!/usr/bin/env bash

# 初始化日志
init_log() {
    mkdir -p $(dirname $LOG_FILE)
    echo "=== System Init Script v$VERSION ===" >> $LOG_FILE
    echo "Start Time: $(date)" >> $LOG_FILE
}

# 错误处理
handle_error() {
    echo -e "${RedBG}Error: $1${Font}" | tee -a $LOG_FILE
    exit 1
}

# 检查命令是否存在
check_command() {
    if ! command -v $1 &> /dev/null; then
        handle_error "$1 command not found"
    fi
}

# 验证输入
validate_input() {
    if [[ ! "$1" =~ ^[Yy][Ee][Ss]$|^[Nn][Oo]$ ]]; then
        echo "Invalid input, please enter yes or no" | tee -a $LOG_FILE
        return 1
    fi
    return 0
}

# 初始化
init_log
check_command curl
check_command apt-get

app_path=/tmp/app
mkdir -p $app_path || handle_error "Failed to create app directory"
# Detect OS
OS="$(uname)"
case $OS in
    "Linux")
        # Detect Linux Distro
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            DISTRO=$ID
            VERSION=$VERSION_ID
            UBUNTU_CODENAME=$UBUNTU_CODENAME
        else
            echo "不支持这个 Linux 发行版"
            exit
        fi
        ;;
esac
# 更换系统源
case $DISTRO in
    "ubuntu")
        echo -e "${Green}您的系统是  Ubuntu $VERSION, 系统代号是 $UBUNTU_CODENAME, 正在换源...${Font}" | tee -a $LOG_FILE
        if ! source <(curl -fsSL ${download_url}/os/apt/ustc-mirror.sh); then
            handle_error "Failed to update apt sources"
        fi
        echo -e "${Green}系统源已更换为中科大源${Font}" | tee -a $LOG_FILE
        
        # 验证源是否更新成功
        if ! apt-get update &>> $LOG_FILE; then
            handle_error "Failed to update package lists"
        fi
        
        echo -e "${Green}正在安装基础软件${Font}" | tee -a $LOG_FILE
        if ! apt-get install -y curl git git-lfs build-essential ssh ntpdate &>> $LOG_FILE; then
            handle_error "Failed to install base packages"
        fi
    ;;
esac

read -p "是否需要安装星火应用商店？桌面版强烈推荐 系统>= 20.04 >(yes/no): " install_star
if [[ "$install_star" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "\033[5;33m 正在安装 星火应用商店....\033[0m"
    source <(curl -s ${download_url}/os/apt/spark.sh)
elif [[ "$install_star" =~ ^[Nn][Oo]$ ]]; then
    echo "星火应用商店安装取消"
else
    echo "无效的输入，星火应用商店安装取消"
fi

read -p "您是否需要安装Todesk远程控制？推荐安装一个，这样出错方便远程介入。(yes/no): " install_todesk
if [[ "$install_todesk" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "\033[5;33m 正在安装 Todesk 远程控制....\033[0m"
    source <(curl -s ${download_url}/os/apt/todesk.sh)
elif [[ "$install_todesk" =~ ^[Nn][Oo]$ ]]; then
    echo "Todesk远程控制安装取消"
else
    echo "无效的输入，Todesk远程控制安装取消"
fi

# 检测到NVIDIA显卡设备
echo -e "${Green}正在检查是否有 NVIDA 显卡设备...${Font}"
NVIDIA_PRESENT=$(lspci | grep -i nvidia || true)

# Only proceed with Nvidia-specific steps if an Nvidia device is detected
if [[ -z "$NVIDIA_PRESENT" ]]; then
    
    echo -e "${RedBG} 未在设备上检测到 Nvidia 显卡设备 ${Font}"
    # source <(curl -s ${download_url}/linux.sh)
else
    echo -e "${Green}检测到 Nvidia 显卡设备 ${Font}" | tee -a $LOG_FILE
    read -p "您是否需要安装NVIDIA显卡驱动？(yes/no): " install_nvidia
    if ! validate_input "$install_nvidia"; then
        echo "取消安装 Nvidia 显卡驱动" | tee -a $LOG_FILE
        return
    fi
    
    if [[ "$install_nvidia" =~ ^[Yy][Ee][Ss]$ ]]; then
        echo -e "\033[5;33m 正在安装 Nvidia 显卡驱动...\033[0m" | tee -a $LOG_FILE
        if ! source <(curl -fsSL ${download_url}/os/apt/nvidia-driver.sh); then
            handle_error "Failed to install NVIDIA driver"
        fi
        
        # 验证驱动安装
        if ! nvidia-smi &>> $LOG_FILE; then
            handle_error "NVIDIA driver installation verification failed"
        fi
        echo -e "${Green}NVIDIA 驱动安装成功${Font}" | tee -a $LOG_FILE
    else
        echo "取消安装 Nvidia 显卡驱动" | tee -a $LOG_FILE
    fi
fi  

read -p "您是否需要解决双系统时间问题? <双系统推荐 yes> (yes/no): " time_problem

if [[ "$time_problem" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "\033[5;33m 正在解决双系统时间问题....\033[0m"
    sudo apt install ntpdate -y
    sudo ntpdate time.windows.com
    sudo hwclock --localtime --systohc
elif [[ "$time_problem" =~ ^[Nn][Oo]$ ]]; then
    echo "取消"
else
    echo "无效的输入，取消"
fi

read -p "您是否需要安装 grub 开机界面, 原神主题 <双系统推荐 y> (yes/no): " yuanshen
if [[ "$yuanshen" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "\033[5;33m 正在安装 grub 开机界面....\033[0m"
    source <(curl -s ${download_url}/os/all/grub.sh)
elif [[ "$yuanshen" =~ ^[Nn][Oo]$ ]]; then
    echo "grub 开机界面设置取消"
else
    echo "无效的输入，grub 开机界面设置取消"
fi

echo -e "${Green}基础配置已完成${Font}" | tee -a $LOG_FILE
read -p "系统需要重启以使更改生效，是否立即重启？(yes/no): " reboot_now
if ! validate_input "$reboot_now"; then
    echo "取消重启" | tee -a $LOG_FILE
    exit 0
fi

if [[ "$reboot_now" =~ ^[Yy][Ee][Ss]$ ]]; then
    echo -e "${Yellow}系统将在5秒后重启...${Font}" | tee -a $LOG_FILE
    echo "按 Ctrl+C 取消重启" | tee -a $LOG_FILE
    sleep 5
    if ! sudo reboot; then
        handle_error "Failed to reboot system"
    fi
else
    echo "取消重启，请手动重启系统以使更改生效" | tee -a $LOG_FILE
fi
