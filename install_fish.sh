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
	$cc install fish
	curl -L https://get.oh-my.fish | fish
	omf install aight
	omf install autojump
	pip install trash-cli #install rm foo -> mv foot foot-bck
	$cc install bat
	$cc install colordiff

	cp ./config_file/config.fish ~/.config/fish/config.fish
}

if [ ! -x "$(command -v fish)" ];then
	write
fi
