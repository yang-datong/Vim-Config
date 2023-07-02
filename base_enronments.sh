#!/bin/bash

set -e

check_proxy(){
	local err=$(echo $https_proxy)
	if [ -z "$err" ];then
		echo 0
	else
		echo 1
	fi
}

if [ $(check_proxy) == 0 ];then
	echo "没有使用代理，确保可以访问github不然环境无法搭建"
	exit
fi

#Check OS System
if [ "$(uname)" == "Linux" ];then
	sudo apt install -y file passwd
fi

./install_aria2c.sh
./install_fish.sh
./install_zsh.sh
./install_vim.sh
./install_neovim.sh
./install_gdb.sh

./tools/replace_symbols_link.sh
./config_file/replace_symbols_link.sh
