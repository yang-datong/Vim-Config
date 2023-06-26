#!/bin/bash

#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") cc=brew;;
	"Linux") cc=apt;;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}

function write(){
	check_os
	#$cc install zsh
	#curl -L https://get.oh-my.fish | fish
	#omf install aight
	#omf install autojump
	pip install trash-cli #install rm foo -> mv foot foot-bck
	$cc install bat
	$cc install colordiff

	cp ./xx.zshrc ~/.zshrc
}

if [ ! -x "$(command -v zsh)" ];then
	write
fi
