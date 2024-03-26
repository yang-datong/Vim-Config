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
	if [ ! -x "$(command -v $obj)" ];then
		echo "$obj installing ....."
		$cc install $cmd
	fi
}

check_py_pack(){
	local cmd=$1
	pip3 show $cmd
	if [ $? == 1 ];then
		pip3 install $cmd
	fi
}

main(){
	check_cmd node nodejs
	check_cmd nvim neovim
	check_py_pack pynvim

	#into main work
	if [ ! -d $HOME/.config/nvim ];then
		mkdir $HOME/.config/nvim
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
