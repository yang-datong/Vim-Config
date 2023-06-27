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
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	$cc install autojump
	pip install trash-cli #install rm foo -> mv foot foot-bck
	$cc install bat
	$cc install colordiff

	cp ./xx.zshrc ~/.zshrc
}

if [ ! -x "$(command -v zsh)" ];then
	write
fi
