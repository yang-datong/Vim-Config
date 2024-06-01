#!/bin/bash

#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") brew install --cask mactex-no-gui;;
		"Linux") sudo apt install -y texlive-full;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}


obj=latex
if [ ! -x "$(command -v $obj)" ];then
	echo "$obj installing ....."
	check_os
else
	echo "$obj installed"
fi
