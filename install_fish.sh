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

function write(){
	check_os
	$cc install fish
	curl -L https://get.oh-my.fish | fish
	fish -c "omf install aight"

	$cc install trash-cli #install rm foo -> mv foot foot-bck
	$cc install bat
	$cc install colordiff

	cp ./config_file/config.fish $HOME/.config/fish/config.fish
	cp ./config_file/fish_prompt.fish $HOME/.config/fish/functions/fish_prompt.fish
	git clone https://github.com/wting/autojump.git $HOME/autojump
	cd $HOME/autojump && ./install.py
}

write
