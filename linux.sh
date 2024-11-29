#!/usr/bin/env bash

clear

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

#核心文件
get_opsy(){
    [ -f /etc/redhat-release ] && awk '{print ($1,$3~/^[0-9]/?$3:$4)}' /etc/redhat-release && return
    [ -f /etc/os-release ] && awk -F'[= "]' '/PRETTY_NAME/{print $3,$4,$5}' /etc/os-release && return
    [ -f /etc/lsb-release ] && awk -F'[="]+' '/DESCRIPTION/{print $2}' /etc/lsb-release && return
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

#变量引用
opsy=$( get_opsy )
cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
tram=$( free -m | awk '/Mem/ {print $2}' )
uram=$( free -m | awk '/Mem/ {print $3}' )
ipaddr=$(curl -s myip.ipip.net | awk -F ' ' '{print $2}' | awk -F '：' '{print $2}')

#脚本菜单
start_linux(){
    echo -e "====================================================="
    echo -e "=             LinuxCTS - 综合Linux脚本              ="
    echo -e "=                                                   ="
    echo -e "=                当前版本 V2.6                      ="
    echo -e "=            更新时间 2022年4月21日                 ="
    echo -e "=                                                   ="
    echo -e "====================================================="
    echo -e "操作系统${Green} $opsy ${Font}CPU${Green} $cores ${Font}核 系统内存${Green} $tram ${Font}MB"
    echo -e "IP地址${Green} $ipaddr $ipdz ${Font}"
    echo -e "====================================================="
    # echo -en "=  ${Green}11${Font}  " && gpt_style_output 'VPS信息和性能测试 VPS information test'
    echo -e "=  ${Green}11${Font}  VPS信息和性能测试 VPS information test" 
    echo -e "=  ${Green}12${Font}  Bench系统性能测试  Bench performance test  "
    echo -e "=  ${Green}13${Font}  Linux系统实用功能  Linux utility function  "
    echo -e "=  ${Green}14${Font}  Linux路由追踪检测  Linux traceroute test  "
    echo -e "="
    echo -e "=  ${Green}21${Font}  Linux修改交换内存  Modify swap memory  "
    echo -e "=  ${Green}22${Font}  Linux修改服务器DNS  Modify server DNS  "
    echo -e "=  ${Green}23${Font}  流媒体区域限制测试  Streaming media testing  "
    echo -e "=  ${Green}24${Font}  Linux系统bbr-tcp加速  System bbr-tcp speed up  "
    echo -e "=  ${Green}25${Font}  Linux网络重装dd系统  Network reloading system  "
    echo -e "="
    echo -e "=  ${Green}31${Font}  Frps服务端-管理脚本  Frps server script  "
    echo -e "=  ${Green}32${Font}  Frps客户端-管理脚本  Frps client script  "
    echo -e "=  ${Green}33${Font}  Nezha哪吒监控-云探针  Nezha monitoring probe  "
    echo -e "=  ${Green}34${Font}  ServerStatus-云探针  ServerStatus probe  "
    echo -e "=  ${Green}35${Font}  iptables-端口转发  Iptables port forwarding  "
    echo -e "=  ${Green}36${Font}  Docker 安装  Docker install  "
    echo -e "=  ${Green}37${Font}  Nvidia显卡驱动安装  nvidia-smi install  "
    echo -e "=  ${Green}38${Font}  Nvidia-Docker安装  nvidia-docker install  "
    echo -e "=  ${Green}39${Font}  Miniconda安装  Miniconda install  "
    echo -e "="
    echo -e "=  ${Green}99${Font}  退出当前脚本  Exit the current script  "
    echo -e "====================================================="
    echo -e -n "=  ${Green}请输入对应功能的${Font}  ${Red}数字：${Font}"
    
    read num
    case $num in
    11)
        source <(curl -s ${download_url}/tools/xncs.sh)
        ;;
    12)
        source <(curl -s ${download_url}/tools/bench.sh)
        ;;
    13)
        source <(curl -s ${download_url}/tools.sh)
        ;;
    14)
        source <(curl -s ${download_url}/tools/tools/lyzz.sh)
        ;;
    21)
        source <(curl -s ${download_url}/tools/swap.sh)
        ;;
    22)
        source <(curl -s ${download_url}/tools/dns.sh)
        ;;
    23)
        source <(curl -s ${download_url}/check.sh)
        ;;
    24)
        source <(curl -s ${download_url}/tcp.sh)
        ;;
    25)
        source <(curl -s ${download_url}/tools/net-install.sh)
        ;;
    31)
        source <(curl -s ${download_url}/tools/frps.sh)
        ;;
    32)
        source <(curl -s ${download_url}/tools/frpc.sh)
        ;;
    33)
        source <(curl -s ${download_url}/tools/nezha.sh)
        ;;
    34)
        source <(curl -s ${download_url}/status.sh)
        ;;
    35)
        source <(curl -s ${download_url}/tools/dkzf.sh)
        ;;
    36)
        install_docker
        ;;
    37)
        source <(curl -s ${download_url}/tools/nvidia-driver.sh)
        ;;
    38)
        source <(curl -s ${download_url}/tools/nvidia-docker.sh)
        ;;
    39)
        echo -e "${Yellow} 安装miniconda,首先需要您退出到普通用户使用下面连接一键安装....  ${Font}"
        echo -e "miniconda安装脚本:  ${Green} source <(curl -s ${download_url}/tools/nvidia-docker.sh) ${Font}"
        ;;
    99)
        echo -e "\n${GreenBG}感谢使用！欢迎下次使用！${Font}\n" && exit
        ;;
    *)
        echo -e "\n${RedBG}未找到该功能！正在退出！${Font}\n" && exit
        ;;
    esac
}

#脚本启动
check_root
sys_install
echo
start_linux
