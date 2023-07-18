#!/bin/bash
set -e

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
	if [[ "$cmd" == "python3.9" && "$cc" == "brew" ]];then
		cmd="python@3.9"
	fi
	if [ ! -x "$(command -v $obj)" ];then
		echo "$obj installing ....."
		$cc install $cmd
	fi
}

main(){
	check_cmd wget wget
	check_cmd node nodejs
	check_cmd python3.9 python3.9
	if [[ ! -x "$(command -v "pip")" &&  ! -x "$(command -v "pip3")" ]];then
		#wget https://bootstrap.pypa.io/get-pip.py
		#python3 get-pip.py  #下载最新版pip，如果用python2执行则下载pip2，反之
		$cc install python3-pip
	fi
	#brew install neovim yarn 
	pip3 install pynvim
	#err=$(pip3 show pynvim)
	#if [ "$err" == "1" ];then	pip3 install pynvim;fi
	check_cmd nvim neovim

	#into main work
	if [ ! -d $HOME/.config/nvim ];then
		mkdir $HOME/.config/nvim
	fi
	cd $HOME/.config/nvim
	cp $HOME/sh_foot/config_file/init.vim  ./init.vim

	$cc install clangd clang-format

	#download plugins
	nvim -c "PlugInstall"

	path=$(dirname $(find . -name "c.snippets"))/
	cp $HOME/sh_foot/config_file/*.snippets $path

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
	file="${HOME}/.config/nvim/plugged/markdown-preview.nvim/app/_static"
	cp ./markdown_theme_file/markdown.css $file/markdown.css
	cp ./markdown_theme_file/page.css $file/page.css
}

check_os
main
#set_markdown_theme
