#!/bin/bash
#https://www.linuxmi.com/ubuntu-install-new-wine.html
set -e

#Linux下的路径: /home/hacksign/.wine/drive_c/Program Files/Python3/
#对应wine下的： C:\Program Files\Python3

if [ ! $(uname) == "Linux" ];then
	echo "非Linux不建议使用wine";exit
fi

sudo dpkg --add-architecture i386 #32bit sup

if [ ! -d /etc/apt/keyrings ];then
	sudo mkdir -pm 755 /etc/apt/keyrings #添加 Wine 存储库密钥
fi

if [ ! -f /etc/apt/keyrings/winehq-archive.key ];then
	sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
fi

version=$( lsb_release -a 2>/dev/null | grep Description: | awk '{print $3}')

if [ ! "$version" == "22.04" ];then
	echo -e "\033[31m不支持的版本\033[0m"
	exit
fi

sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources
sudo apt update 
sudo apt install --install-recommends winehq-stable -y
