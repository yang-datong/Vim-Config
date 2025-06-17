#!/bin/bash

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";;
		"Linux") cc="sudo apt -y";;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}

#Checkout is install
check_cmd(){
	local obj=$1
	local cmd=$2
	if [ ! -x "$(command -v $obj)" ];then
		echo "$obj installing ....."
		$cc install $cmd
	fi
}

check_py_pack(){
	local cmd=$1
	pip3 show $cmd #这条命令不能开启set -e参数给shell
	if [ $? == 1 ];then
		pip3 install $cmd
	fi
}

main(){
	check_cmd node nodejs
	if [ $(uname) == "Linux" ];then
		add-apt-repository --list | grep neovim
		if [ $? != 0 ];then
			sudo add-apt-repository ppa:neovim-ppa/stable -y
		fi
		sudo apt update
	fi
	check_cmd nvim neovim
	check_py_pack pynvim
	check_py_pack neovim-remote
	./install_nodejs.sh

	#into main work
	if [ ! -d $HOME/.config/nvim ];then
		mkdir $HOME/.config/nvim
	fi
	if [ ! -d $HOME/.config/nvim/autoload ];then
		mkdir $HOME/.config/nvim/autoload
	fi
	if [ ! -f $HOME/.config/nvim/autoload/plug.vim ];then
		cp $SH_FOOT/config_file/nvim/plug.vim  $HOME/.config/nvim/autoload/plug.vim
	fi

	cp $SH_FOOT/config_file/init.vim  $HOME/.config/nvim/init.vim

	#download plugins
	nvim -c "PlugInstall"

	read -p "is need set markdown theme?[y/N]" theme
	if [ "$theme" == "y" ];then
		set_markdown_theme
	fi;

	if [ -f get-pip.py ];then
		rm get-pip.py
	fi

	#cd ~/.config/nvim/plugins/markdown-preview.nvim
	#yarn install && yarn upgrade
}

set_markdown_theme(){
	file="$HOME/.config/nvim/plugged/markdown-preview.nvim/app/_static"
	cp $SH_FOOT/markdown_theme_file/markdown.css $file/markdown.css
	cp $SH_FOOT/markdown_theme_file/page.css $file/page.css
}

check_os
main
