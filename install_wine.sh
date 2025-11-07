#!/bin/bash
#https://www.linuxmi.com/ubuntu-install-new-wine.html
set -ex

#Linux下的路径: /home/hi/.wine/drive_c/Program Files/Python3/
#对应wine下的： C:\Program Files\Python3

sudo dpkg --add-architecture i386 #32bit sup

if [ ! -d /etc/apt/keyrings ]; then
	sudo mkdir -pm 755 /etc/apt/keyrings #添加 Wine 存储库密钥
fi

if [ ! -f /etc/apt/keyrings/winehq-archive.key ]; then
	sudo wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key
fi

sudo wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/$(lsb_release -sc)/winehq-$(lsb_release -sc).sources
sudo apt update

sudo apt install --install-recommends winehq-stable -y
