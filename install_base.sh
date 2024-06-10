#!/bin/bash
set -e

main(){
	check_os
	if [ ! $SH_FOOT ];then
		if [ ! -d $HOME/sh_foot ];then
			echo -e "\033[31m建议使用ssh key的方式来管理[Ok]\033[0m"
			read ok
			git clone git@github.com:yang-datong/Vim-Config.git $HOME/sh_foot
		fi
		echo "Setting environment to \$SH_FOOT"; export SH_FOOT=$HOME/sh_foot
	fi

	pushd $SH_FOOT
	#Check OS System
	if [ "$(uname)" == "Linux" ];then
		sudo add-apt-repository ppa:deadsnakes/ppa
		sudo apt update
		sudo apt install -y file passwd python3.10 android-sdk-platform-tools #android-tools-adb
	elif [ "$(uname)" == "Darwin" ];then
		if [ ! -x "$(command -v brew)" ];then ./install_brew.sh;fi
		brew install coreutils python@3.10
		brew install --cask android-platform-tools
	fi


	$cc install curl wget git axel scrcpy
	if [ ! -f get-pip.py ];then
		curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	fi
	python3.10 get-pip.py
	if [ -f get-pip.py ];then
		rm get-pip.py
	fi
	./install_aria2c.sh #下载工具
	#./install_fish.sh
	./install_zsh.sh
	./install_neovim.sh
	./install_vim_anywhere.sh

	./tools/replace_symbols_link.sh
	./config_file/replace_symbols_link.sh
	popd
}

check_proxy(){
	local err=$(echo $https_proxy)
	if [ -z "$err" ];then
		echo 0
	else
		echo 1
	fi
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";;
		"Linux") cc="sudo apt -y";;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}

#if [ $(check_proxy) == 0 ];then
#	echo "没有使用代理，确保可以访问github不然环境无法搭建";exit
#fi

main
