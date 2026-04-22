#!/bin/bash

ubuntu(){
	# Download and Install flutter
	sudo snap install flutter --classic

	# Install sdk
	flutter sdk-path

	# Into Android-Studio going to SDK Manager, switch to the SDK Tools tab and check Android SDK Command-line Tools (latest).

	# Install the VScode software
	# Accept the SDK licenses.
	flutter doctor --android-licenses

	flutter doctor
	# Into Android-Studio going to Plugins and search flutter , check install
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") echo "null";exit ;;
		"Linux") ubuntu;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}
check_os
