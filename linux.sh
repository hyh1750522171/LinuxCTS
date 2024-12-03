#!/usr/bin/env bash

ipdz=$(curl -s myip.ipip.net | awk -F '：' '{print $3}')
#全局参数
url=https://ifconfig.icu
country=$(curl -s ${url}/country)
if [[ $country == *"China"* ]]; then
    download_url=https://gitee.com/muaimingjun/LinuxCTS/raw/main
else
    download_url=https://raw.githubusercontent.com/hyh1750522171/LinuxCTS/main
fi

source <(curl -s ${download_url}/tools/init.sh)

#脚本菜单
start_linux(){
    clear
    echo -e "\033[42;37m您计算机所在的国家地区:\033[0m \033[32m ${ipdz} \033[0m"
    headers
    # echo -en "=  ${Green}11${Font}  " && gpt_style_output 'VPS信息和性能测试 VPS information test'
    echo -e "=  ${Green}11${Font}  Linux信息和性能测试 VPS information test" 
    echo -e "=  ${Green}12${Font}  Bench系统性能测试  Bench performance test  "
    echo -e "=  ${Green}13${Font}  Linux常用工具安装  Linux utility function  "
    echo -e "=  ${Green}14${Font}  Linux路由追踪检测  Linux traceroute test  "
    echo -e "="
    echo -e "=  ${Green}21${Font}  Linux修改交换内存  Modify swap memory  "
    echo -e "=  ${Green}22${Font}  Linux修改服务器DNS  Modify server DNS  "
    echo -e "=  ${Green}23${Font}  流媒体区域限制测试  Streaming media testing  "
    echo -e "=  ${Green}24${Font}  Linux系统bbr-tcp加速  System bbr-tcp speed up  "
    echo -e "=  ${Green}25${Font}  Linux网络重装dd系统  Network reloading system  "
    echo -e "=  ${Green}26${Font}  CentOS 7 更换Aliyun的源  Modify Mirror For CentOS7  "
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
        source <(curl -s ${download_url}/tools/tools.sh)
        ;;
    14)
        source <(curl -s ${download_url}/tools/lyzz.sh)
        ;;
    21)
        source <(curl -s ${download_url}/tools/swap.sh)
        ;;
    22)
        source <(curl -s ${download_url}/tools/dns.sh)
        ;;
    23)
        source <(curl -s ${download_url}/tools/check.sh)
        ;;
    24)
        source <(curl -s ${download_url}/tools/tcp.sh)
        ;;
    25)
        source <(curl -s ${download_url}/tools/net-install.sh)
        ;;
    26)
        source <(curl -s ${download_url}/tools/clean_and_set_mirror_centos7.sh)
        ;;
    99)
        echo -e "\n${GreenBG}感谢使用！欢迎下次使用！${Font}\n" && exit
        ;;
    *)
        clear
        echo -e "${Error}:请输入正确数字 [0-99], 5秒后刷新"
        countdown_sleep 5
        start_linux
        ;;
    esac
}

#脚本启动
check_root
sys_install
echo
start_linux
