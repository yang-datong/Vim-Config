#!/bin/bash

cc="brew"

ubuntu() {
	curl -sL https://deb.nodesource.com/setup_22.x | sudo -E bash -
	$cc install -y nodejs
}

macos() {
	$cc install nodejs
}

#Check OS System
check_os() {
	case "$(uname)" in
	"Darwin")
		cc="brew"
		macos
		;;
	"Linux")
		cc="sudo apt -y"
		ubuntu
		;;
	*)
		echo "Windows has not been tested for the time being"
		exit 1
		;;
	esac
}

check_os
