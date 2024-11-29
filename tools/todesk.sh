#!/usr/bin/env bash

Version=v4.7.2.0
package="todesk-${Version}-amd64.deb" 
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
# 检查安装todesk
install_todesk(){
  PACKAGE_NAME="todesk"
  if ! command -v $PACKAGE_NAME &> /dev/null; then
    wget --no-check-certificate https://dl.todesk.com/linux/${package} -O /tmp/${package}
    apt install /tmp/${package}
    systemctl start todeskd.service
    rm -fr /tmp/${package}
  else
    echo "$PACKAGE_NAME 已安装."
  fi
}

# 检查是否安装并运行了GNOME桌面环境
gnome_check=$(ps -ef | grep gnome-session | grep -v grep)
if [ -n "$gnome_check" ]; then
    install_todesk
    # 这里可以添加你想要在有GNOME桌面环境时执行的具体操作
    exit 0
else
    echo "当前没有GNOME桌面环境，无法安装Todesk。"
fi



