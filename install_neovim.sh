#!/bin/bash


#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") cc=brew;;
	"Linux") cc=apt;;
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
main(){
	check_cmd wget wget
	check_cmd node nodejs
	if [ ! -x "$(command -v "pip")" ];then
		wget https://bootstrap.pypa.io/get-pip.py
		python get-pip.py
	fi
	#brew install neovim yarn && pip3 install pynvim
	err=$(pip3 show pynvim)
	if [ "$err" == "1" ];then	pip3 install pynvim;fi
	check_cmd nvim neovim

	#into main work
	cd $HOME/.config/nvim
	cp $HOME/sh_foot/config_file/init.vim  ./init.vim

	err=$(echo $https_proxy)
	#if [ -z "$err" ];then
	#	echo "export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"
	#	read -p "?" ok
	#fi
	#download plugins
	nvim -c "PlugInstall"

	path=$(dirname $(find . -name "c.snippets"))/
	cp $HOME/sh_foot/config_file/*.snippets $path

	read -p "is need set markdown theme?[y/N]" theme
	if [ "$theme" == "y" ];then
		set_markdown_theme
	fi;

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
