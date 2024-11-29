#!/usr/bin/env bash


# 全局变量
Green="\033[32m"
Red="\033[31m"
YellowBG="\033[43;37m"
Yellow="\033[33m"
blue="\033[44;37m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"
shanshuo1="\033[5m"
shanshuo2="\033[0m"


ipdz=$(curl -s myip.ipip.net | awk -F '：' '{print $3}')
#全局参数
url=https://ifconfig.icu
country=$(curl -s ${url}/country)
echo -e "${GreenBG}您计算机所在的国家地区:${Font} ${Green} ${ipdz} ${Font}"
if [[ $country == *"China"* ]]; then
    download_url=https://gitee.com/muaimingjun/LinuxCTS/raw/main
else
    download_url=https://raw.githubusercontent.com/hyh1750522171/LinuxCTS/main
fi


#检查账号
check_root(){
	if [[ $EUID != 0 ]];then
		echo -e "${RedBG}当前不是ROOT账号，建议更换ROOT账号使用。${Font}"
		echo -e "${Yellow}不要是用 sudo 执行脚本，直接使用 ROOT 账号执行。${Font} "
		sleep 5
        exit 1
	fi
}

#安装依赖
sys_install(){
    if ! type wget >/dev/null 2>&1; then
        echo -e "${RedBG}wget 未安装，准备安装！${Font}"
	    apt-get install wget -y || yum install wget -y
    fi
}

# 定义函数，使其可以接受参数
function gpt_style_output() {
    local text="$1"
    for ((i = 0; i < ${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep 0.05
    done
    echo ""
}

# 检查安装Docker
install_docker(){
    PACKAGE_NAME="docker"
    if ! command -v $PACKAGE_NAME &> /dev/null; then
        source <(curl -s ${download_url}/tools/get-docker.sh)
    else
        echo "$PACKAGE_NAME 已安装."
    fi
}

#核心文件
get_opsy(){
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
}


#变量引用
opsy=$( get_opsy )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
ipaddr=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')

headers(){
    echo -e "${blue}=====================================================${Font}"
    echo -e "${blue}=             LinuxCTS - 综合Linux脚本              =${Font}"
    echo -e "${blue}=                                                   =${Font}"
    echo -e "${blue}=                当前版本 V2.6                      =${Font}"
    echo -e "${blue}=            更新时间 2024年11月29日                =${Font}"
    echo -e "${blue}=              bug 反馈 ⬇⬇⬇⬇⬇⬇😳                    =${Font}"
    echo -e "${blue}= https://github.com/hyh1750522171/LinuxCTS/issues  =${Font}"
    echo -e "${blue}=                                                   =${Font}"
    echo -e "${blue}=====================================================${Font}"
    echo -e "操作系统${Green} $opsy ${Font}CPU${Green} $cores ${Font}核 系统内存${Green} $tram ${Font}MB"
    echo -e "IP地址${Green} $ipaddr $ipdz ${Font}"
    echo -e "====================================================="
}
# headers 
