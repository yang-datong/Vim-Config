#!/bin/bash

main() {
	check_os
	if [ "$(arch)" == "arm64" ]; then
		if [ ! -d /usr/local/bin ]; then
			sudo mkdir /usr/local/bin
		fi
	fi

	if [ ! $SH_FOOT ]; then
		if [ ! -d $HOME/sh_foot ]; then
			echo -e "\033[31m建议使用ssh key的方式来管理[Ok]\033[0m"
			read ok
			git clone git@github.com:yang-datong/Vim-Config.git $HOME/sh_foot
		fi
		echo "Setting environment to \$SH_FOOT ,Used $HOME/sh_foot"
		export SH_FOOT=$HOME/sh_foot
	fi

	pushd $SH_FOOT
	#Check OS System
	if [ "$(uname)" == "Linux" ]; then
		sudo apt update
		sudo apt install -y software-properties-common
		add-apt-repository --list | grep deadsnakes
		if [ $? != 0 ]; then
			sudo add-apt-repository ppa:deadsnakes/ppa -y
		fi
		sudo apt install -y file passwd python3.10 gcc g++ gdb make cmake android-sdk-platform-tools #android-tools-adb
	elif [ "$(uname)" == "Darwin" ]; then
		if [ ! -x "$(command -v brew)" ]; then ./install_brew.sh; fi
		eval "$(/opt/homebrew/bin/brew shellenv)" #Apple silicon M1芯片安装的brew会在/opt目录下
		brew install coreutils python@3.10
		brew install --cask android-platform-tools
	fi

	$cc install curl wget git axel scrcpy
	if [ ! -f /usr/local/bin/python3.10 ]; then
		if [ "$(arch)" == "arm64" ]; then
			sudo ln -s /opt/homebrew/bin/python3.10 /usr/local/bin/python3.10
		else
			sudo ln -s /usr/bin/python3.10 /usr/local/bin/python3.10
		fi
	fi
	if [ ! -f get-pip.py ]; then
		curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
	fi
	python3.10 get-pip.py
	if [ -f get-pip.py ]; then
		rm get-pip.py
	fi
	if [ "$(uname)" == "Linux" ]; then
		sudo apt install -y clang-format clangd universal-ctags fzf  silversearcher-ag translate-shell
	elif [ "$(uname)" == "Darwin" ]; then
		brew install clangd-format ctags fzf the_silver_searcher translate-shell
	fi
	./install_aria2c.sh #下载工具
	./install_fish.sh
	./install_zsh.sh
	./install_neovim.sh
	./install_vim_anywhere.sh

	./tools/replace_symbols_link.sh
	./config_file/replace_symbols_link.sh
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
