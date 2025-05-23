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

write(){
	if [ ! $SH_FOOT ];then
		echo "Setting environment to \$SH_FOOT"; export SH_FOOT=$HOME/sh_foot
	fi
	$cc install fish
	curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
	#curl -L https://get.oh-my.fish | fish
	fish -c "omf install aight"

	$cc install trash-cli #install rm foo -> mv foot foot-bck
	pip3 install trash-cli
	$cc install bat
	$cc install colordiff

	if [ ! -d $HOME/autojump ];then
		git clone https://github.com/wting/autojump.git $HOME/autojump
	fi
	local date=$(date +"%Y%m%d%H%M%S")
	cd $HOME/autojump && ./install.py && mv $HOME/autojump /tmp/autojump_${date}
	echo -e "\033[31mExec 'set --erase fish_greeting' close prompt\033[0m"
}

check_os
write
