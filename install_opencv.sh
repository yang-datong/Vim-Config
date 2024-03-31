#!/bin/bash

macos(){
	$cc install opencv
	#头文件:/opt/homebrew/include/opencv4/opencv2/
	#库文件:/opt/homebrew/lib/
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") cc="brew";macos;;
	"Linux") cc="sudo apt -y";;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os
