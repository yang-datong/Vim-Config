#!/bin/bash

cc="brew"

ubuntu(){
	curl -sL https://deb.nodesource.com/setup_21.x | sudo -E bash -
	$cc install -y nodejs
}

macos(){
	echo -e "\033[31mTODO\033[0m"
}


#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";macos;;
		"Linux") cc="sudo apt -y";ubuntu;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os
