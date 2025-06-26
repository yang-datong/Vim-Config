#!/bin/bash

#set -e #开启后使用grep判断会有问题

install_base_env_linux(){
	#对于Ubuntu for Arm: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu-ports/
	#对于Ubuntu for x86: https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu/
	sudo apt update
	#安装Ubuntu集成工具，如release_lsb、add-apt-repository
	sudo apt install -y software-properties-common
	add-apt-repository --list | grep deadsnakes
	if [ $? != 0 ]; then
		sudo add-apt-repository ppa:deadsnakes/ppa -y
	fi

	sudo apt install -y file passwd python3.10 gcc g++ gdb make cmake git wget curl
	sudo apt install -y clang-format universal-ctags fzf  silversearcher-ag translate-shell
	sudo apt install -y clangd
	sudo apt install -y android-sdk-platform-tools
}

install_base_env_mac(){
	# 首先安装brew
	if [ ! -x "$(command -v brew)" ]; then ./install_brew.sh; fi
	if [ "$(arch)" == "arm64" ]; then
		#MacOS for Arm 安装的brew会在/opt目录下
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	#NOTE: https://mirrors.tuna.tsinghua.edu.cn/help/homebrew/
	#主仓库
	export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
	#加速软件包信息查询
	export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
	#加速软件包安装下载
	export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
	brew update

	brew install coreutils python@3.10 make cmake git wget curl
	brew install clang-format ctags fzf the_silver_searcher translate-shell
	#brew install clangd  #不需要单独安装clangd，默认集成
	brew install --cask android-platform-tools
}

clean(){
	if [ -f get-pip.py ]; then rm get-pip.py; fi
}

main() {
	check_os
	# MacOS for Arm 默认没有/usr/local/bin 目录
	if [ "$(uname)" == "Darwin" ] && [ "$(arch)" == "arm64" ]; then
		if [ ! -d /usr/local/bin ]; then
			sudo mkdir /usr/local/bin
		fi
	fi

	if [ ! $SH_FOOT ]; then
		if [ ! -d $HOME/sh_foot ]; then
			git clone https://github.com/yang-datong/Vim-Config.git $HOME/sh_foot
			#echo -e "\033[31m建议使用ssh key的方式来管理[Ok]\033[0m"
			#read ok
			#git clone git@github.com:yang-datong/Vim-Config.git $HOME/sh_foot
		fi
		echo "Setting environment to \$SH_FOOT ,Used $HOME/sh_foot"
		export SH_FOOT=$HOME/sh_foot
	fi

	pushd $SH_FOOT
	#Check OS System
	if [ "$(uname)" == "Linux" ]; then
		install_base_env_linux
	elif [ "$(uname)" == "Darwin" ]; then
		install_base_env_mac
	fi

	if [ ! -f /usr/local/bin/python3.10 ]; then
		if [ "$(uname)" == "Darwin" ] && [ "$(arch)" == "arm64" ]; then
			sudo ln -s /opt/homebrew/bin/python3.10 /usr/local/bin/python3.10
		else
			sudo ln -s /usr/bin/python3.10 /usr/local/bin/python3.10
		fi
	fi

	if [ ! -f get-pip.py ]; then
		curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	fi
	#sudo apt install python3-pip -y? python 3.11以上需要指定一个虚拟环境安装
	if [ "$(uname)" == "Linux" ] && [ "$(arch)" == "aarch64" ]; then
		python3.10 get-pip.py --break-system-packages #TODO:这样是不推荐的
		export PATH=$PATH:$HOME/.local/bin
	else
		python3.10 get-pip.py
	fi

	./install_zsh.sh
	./install_fish.sh
	./install_neovim.sh
	./install_gdb.sh
	./install_aria2c.sh

	pip3 install pyautogui
	./install_vim_anywhere.sh

	./tools/replace_symbols_link.sh
	./config_file/replace_symbols_link.sh

	clean
	popd
}

cc="brew"
#Check OS System
check_os() {
	case "$(uname)" in
		"Darwin") cc="brew" ;;
		"Linux") cc="sudo apt -y" ;;
		*)
			echo "Windows has not been tested for the time being"
			exit 1
			;;
	esac
}

main "$@"
