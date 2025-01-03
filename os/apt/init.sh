#!/usr/bin/env bash

app_path=/tmp/app
mkdir -p $app_path  
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
        echo -e "${Green}您的系统是  Ubuntu $VERSION, 系统代号是 $UBUNTU_CODENAME, 正在换源...${Font}"
        if [[ "$VERSION" == "24.04" ]]; then
            sudo mv /etc/apt/sources.list.d/ubuntu.sources /etc/apt/sources.list.d/ubuntu.sources.bak
            udo wget -O /etc/apt/sources.list.d/ubuntu.sources  https://mirrors.ustc.edu.cn/repogen/conf/ubuntu-https-4-$UBUNTU_CODENAME
        else
            sudo mv /etc/apt/sources.list /etc/apt/sources.list.bak
            sudo wget -O /etc/apt/sources.list  https://mirrors.ustc.edu.cn/repogen/conf/ubuntu-https-4-$UBUNTU_CODENAME
            
        fi
        sudo apt update && sudo apt upgrade -y
    ;;
esac

read -p "是否需要安装星火应用商店？<桌面版强烈推荐 >= 20.04 >(y/n): " install_star
if [[ "$install_star" == "y" ]]; then
    source <(curl -s ${download_url}/os/apt/spark.sh)
fi 


read -p "您是否需要安装Todesk远程控制？推荐安装一个，这样出错方便远程介入。(y/n): " install_todesk
if [[ "$install_todesk" == "y" ]]; then
    source <(curl -s ${download_url}/os/apt/todesk.sh)
fi

read -p "是否需要安装向日葵远程控制？此项与todesk二选一(y/n): " install_sun
if [[ "$install_sun" == "y" ]]; then
    wget -O $app_path/wechat.deb https://dw.oray.com/sunlogin/linux/SunloginClient_15.2.0.63064_amd64.deb
fi

if [[ "$VERSION" == "20.04" ]]; then
    echo "Ubuntu版本为20.04...."
    echo "正在下载安装搜狗输入法"
    wget -O $app_path/sogou.deb https://minetest.top/upload/sogoupinyin_4.2.1.145_amd64.deb
    sudo apt install fcitx libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1 gnome-tweaks chrome-gnome-shell variety -y
    sudo apt purge ibus* -y && sudo apt autopurge -y
    sudo dpkg -i $app_path/sogou.deb
    sudo apt install -f
    echo "输入法已完成安装，现在我们需要手动启用它。搜狗基于fcitx框架，我们可以通过im-config这个工具来指定。"
    echo "安装完成"
    sleep 2
    echo "请在弹出的窗口内选择确定，然后选是，并选择fcitx作为输入法框架，并按提示完成设置。"
    sleep 10
    im-config
    echo "输入法已完成设置，重启后生效， 如果您是英语的环境，还需在重启后添加搜狗输入法作为键盘。"
elif [[ "$VERSION" == "18.04" ]]; then
    echo "Ubuntu版本为18.04，..."
    echo "正在下载安装搜狗输入法"
    wget -O $app_path/sogou.deb https://minetest.top/upload/sogoupinyin_4.2.1.145_amd64.deb
    sudo apt install fcitx libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1 gnome-tweaks chrome-gnome-shell variety -y
    sudo apt purge ibus* -y && sudo apt autopurge -y
    sudo dpkg -i $app_path/sogou.deb
    sudo apt install -f
    echo "输入法已完成安装，现在我们需要手动启用它。搜狗基于fcitx框架，我们可以通过im-config这个工具来指定。"
    echo "安装完成"
    sleep 2
    echo "请在弹出的窗口内选择确定，然后选是，并选择fcitx作为输入法框架，并按提示完成设置。"
    sleep 10
    im-config
    echo "输入法已完成设置，重启后生效， 如果您是英语的环境，还需在重启后添加搜狗输入法作为键盘。"
elif [[ "$VERSION" == "22.04" ]]; then
    echo "Ubuntu版本是22.04，执行下载操作..."
    echo "您的系统高于20.04，建议使用fcitx5作为中文输入法，正在安装..."
    sudo apt install fcitx5 fcitx5-chinese-addons fcitx5-frontend-gtk2 gnome-tweaks chrome-gnome-shell variety -y
    echo "安装完成"
    sleep 2
    echo "请在弹出的窗口内选择OK，然后选是，并选择fcitx5作为输入法框架，并按提示完成设置。"
    sleep 10
    im-config
    echo "输入法已完成设置"
elif [[ "$VERSION" == "24.04" ]]; then
    echo "您的Ubuntu版本是24.04，执行下载操作..."
    echo "您的系统高于20.04，建议使用fcitx5作为中文输入法，正在安装..."
    sudo apt install fcitx5 fcitx5-chinese-addons fcitx5-frontend-gtk2 fcitx5-frontend-tmux gnome-tweaks chrome-gnome-shell variety -y
    echo "请在弹出的窗口内选择是，并选择fcitx5作为输入法框架，并按提示完成设置。"
    im-config
    echo "输入法已完成设置，如果您的系统是英语环境，还需重启后添加键盘。"
else
    echo "Ubuntu版本是$VERSION，不需要执行任何操作。"
fi

read -p "是否需要安装搜狗输入法？(y/n): " sougou
if [[ "$sougou" == "y" ]]; then
    echo "正在下载安装搜狗输入法"
    wget -O $app_path/sogou.deb https://minetest.top/upload/sogoupinyin_4.2.1.145_amd64.deb
    sudo apt install fcitx libqt5qml5 libqt5quick5 libqt5quickwidgets5 qml-module-qtquick2 libgsettings-qt1 gnome-tweaks chrome-gnome-shell variety -y
    sudo apt purge ibus* -y && sudo apt autoremove -y
    sudo dpkg -i $app_path/sogou.deb
    sudo apt install -f
    rm $app_path/sogou.deb
fi

read -p "是否需要安装微信？(y/n): " install_wechat
if [[ "$install_wechat" == "y" ]]; then
    wget -O $app_path/wechat.deb https://dldir1v6.qq.com/weixin/Universal/Linux/WeChatLinux_x86_64.deb
fi 

read -p "您是否需要安装QQ？(y/n): " install_qq
if [[ "$install_qq" == "y" ]]; then
    wget -O $app_path/qq.deb https://dldir1.qq.com/qqfile/qq/QQNT/Linux/QQ_3.2.13_241023_amd64_01.deb
fi

read -p "您是否需要解决双系统时间问题? <双系统推荐 y> (y/n): " time_problem
if [[ "$time_problem" == "y" ]]; then
    echo "双系统会有时间不一致的问题，此项可以通过ntpdate和hwclock解决"
    sudo apt install ntpdate -y
    sudo ntpdate time.windows.com
    sudo hwclock --localtime --systohc
fi

echo "基础配置已完成，系统将在5秒后重启，重启后驱动即可生效"
sleep 5
sudo reboot