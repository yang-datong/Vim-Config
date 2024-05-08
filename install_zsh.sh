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

	if [ ! -x "$(command -v zsh)" ];then
		echo "zsh installing ....."
		$cc install zsh
	fi

	local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
	if [ ! -d $ZSH_CUSTOM ];then
		bash ./oh-my-zsh.sh
	fi

	local plug_dir=${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
	if [ ! -d $plug_dir ];then
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $plug_dir
	fi

	local plug_dir=${ZSH_CUSTOM}/plugins/zsh-autosuggestions
	if [ ! -d $plug_dir ];then
		git clone https://github.com/zsh-users/zsh-autosuggestions $plug_dir
	fi

	#因为zsh很可能会是临时用在其他终端中，那么安装这些东西可能会有写配置问题
	#$cc install trash-cli #install rm foo -> mv foot foot-bck
	#pip3 install trash-cli
	#$cc install bat
	#$cc install colordiff

	if [ ! -d ${ZSH_CUSTOM}/themes ];then
		mkdir ${ZSH_CUSTOM}/themes
	fi
	echo "UFJPTVBUPSIlRnsjZmZmZmZmfSQgJWYiClJQUk9NUFQ9IiV7JGZnW2JsdWVdJX0kKGhvc3RuYW1lIC1JIHwgY3V0IC1kJyAnIC1mMSkleyRyZXNldF9jb2xvciV9ICV7JGZnW3llbGxvd10lfSV+ICV7JHJlc2V0X2NvbG9yJX0lICIK"  | base64 -d > ${ZSH_CUSTOM}/themes/example.zsh-theme
	cp $SH_FOOT/config_file/shell/xx.zshrc $HOME/.zshrc
}

check_os
write
