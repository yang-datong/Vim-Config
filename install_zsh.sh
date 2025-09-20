#!/bin/bash
set -e

cc="brew"
#Check OS System
check_os() {
	case "$(uname)" in
	"Darwin") cc="brew" ;;
	"Linux") cc="sudo apt -y" ;;
	*)
		echo "Windows has not been tested for the time being"
		exit 1
		;;
	esac
}

write() {
	if [ ! $SH_FOOT ]; then
		echo "Setting environment to \$SH_FOOT"
		export SH_FOOT=$HOME/sh_foot
	fi

	if [ ! -x "$(command -v zsh)" ]; then
		echo "zsh installing ....."
		$cc install zsh
	fi

	local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
	if [ ! -d $ZSH_CUSTOM ]; then
		bash ./oh-my-zsh.sh
	fi

	local plug_dir=${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
	if [ ! -d $plug_dir ]; then
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $plug_dir
	fi

	local plug_dir=${ZSH_CUSTOM}/plugins/zsh-autosuggestions
	if [ ! -d $plug_dir ]; then
		git clone https://github.com/zsh-users/zsh-autosuggestions $plug_dir
	fi

	#因为zsh很可能会是临时用在其他终端中，那么安装这些东西可能会有写配置问题
	#$cc install trash-cli #install rm foo -> mv foot foot-bck
	#pip3 install trash-cli
	#$cc install bat
	#$cc install colordiff

	if [ ! -d ${ZSH_CUSTOM}/themes ]; then
		mkdir ${ZSH_CUSTOM}/themes
	fi
	echo "IyBQdXQgeW91ciBjdXN0b20gdGhlbWVzIGluIHRoaXMgZm9sZGVyLgojIFNlZTogaHR0cHM6Ly9naXRodWIuY29tL29obXl6c2gvb2hteXpzaC93aWtpL0N1c3RvbWl6YXRpb24jb3ZlcnJpZGluZy1hbmQtYWRkaW5nLXRoZW1lcwojCiMgRXhhbXBsZToKClBST01QVD0nJSg/LCV7JGZnW3doaXRlXSV9LCV7JGZnW3JlZF0lfSkkICUgJwojUlBTMT0nJXskZmdbd2hpdGVdJX0lMn4kKGdpdF9wcm9tcHRfaW5mbyknCiNQUk9NUFQ9IiV7JGZnW3JlZF0lfSVuJXskcmVzZXRfY29sb3IlfUAleyRmZ1tibHVlXSV9JW0gJXskZmdbeWVsbG93XSV9JX4gJXskcmVzZXRfY29sb3IlfSUlICIKUlBST01QVD0iJXskZmdbYmx1ZV0lfSV7JHJlc2V0X2NvbG9yJX0gJXskZmdbeWVsbG93XSV9JX4gJXskcmVzZXRfY29sb3IlfSUgIgoKZXhwb3J0IExTQ09MT1JTPSJleGZ4Y3hkeGJ4YnhieGJ4YnhieGJ4IgojZXhwb3J0IExTX0NPTE9SUz0iZGk9MzQ7NDA6bG49MzU7NDA6c289MzI7NDA6cGk9MzM7NDA6ZXg9MzE7NDA6YmQ9MzE7NDA6Y2Q9MzE7NDA6c3U9MzE7NDA6c2c9MzE7NDA6dHc9MzE7NDA6b3c9MzE7NDA6Igo=" | base64 -d >${ZSH_CUSTOM}/themes/example.zsh-theme
	#cp $SH_FOOT/config_file/shell/xx.zshrc $HOME/.zshrc
}

check_os
write
