#!/bin/bash

#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") cc=brew;;
	"Linux") cc="apt -y";;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}

function write(){
	check_os
	$cc install fish
	curl -L https://get.oh-my.fish | fish
	omf install aight
	omf install autojump
	pip3 install trash-cli #install rm foo -> mv foot foot-bck
	$cc install bat
	$cc install colordiff

	cp ./config_file/config.fish ~/.config/fish/config.fish
	cp ./config_file/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish

}

write
