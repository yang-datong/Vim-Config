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
	$cc install zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	local ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

	local plug_dir=${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
	if [ ! -d $plug_dir ];then
		git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $plug_dir
	fi

	local plug_dir=${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting
	if [ ! -d $plug_dir ];then
		git clone https://github.com/zsh-users/zsh-autosuggestions $plug_dir
	fi

	$cc install trash-cli #install rm foo -> mv foot foot-bck
	pip3 install trash-cli
	$cc install bat
	$cc install colordiff

	if [ ! -d $HOME/autojump ];then
		git clone https://github.com/wting/autojump.git $HOME/autojump
	fi

	#echo "IyBQdXQgeW91ciBjdXN0b20gdGhlbWVzIGluIHRoaXMgZm9sZGVyLgojIFNlZTogaHR0cHM6Ly9naXRodWIuY29tL29obXl6c2gvb2hteXpzaC93aWtpL0N1c3RvbWl6YXRpb24jb3ZlcnJpZGluZy1hbmQtYWRkaW5nLXRoZW1lcwojIAojIEV4YW1wbGU6CgojUFJPTVBUPSIleyRmZ1tyZWRdJX0lbiV7JHJlc2V0X2NvbG9yJX1AJXskZmdbYmx1ZV0lfSVtICV7JGZnW3llbGxvd10lfSV+ICV7JHJlc2V0X2NvbG9yJX0lJSAiCgpQUk9NUFQ9JyUoPywleyRmZ1t3aGl0ZV0lfSwleyRmZ1tyZWRdJX0pJCAlICcKUlBTMT0nJXskZmdbd2hpdGVdJX0lMn4kKGdpdF9wcm9tcHRfaW5mbyknCgpleHBvcnQgTFNDT0xPUlM9ImV4ZnhjeGR4YnhieGJ4YnhieGJ4YngiCmV4cG9ydCBMU19DT0xPUlM9ImRpPTM0OzQwOmxuPTM1OzQwOnNvPTMyOzQwOnBpPTMzOzQwOmV4PTMxOzQwOmJkPTMxOzQwOmNkPTMxOzQwOnN1PTMxOzQwOnNnPTMxOzQwOnR3PTMxOzQwOm93PTMxOzQwOiIK" | base64 -d > ${ZSH_CUSTOM}/themes/example.zsh-theme
	echo "IyBQdXQgeW91ciBjdXN0b20gdGhlbWVzIGluIHRoaXMgZm9sZGVyLgojIFNlZTogaHR0cHM6Ly9naXRodWIuY29tL29obXl6c2gvb2hteXpzaC93aWtpL0N1c3RvbWl6YXRpb24jb3ZlcnJpZGluZy1hbmQtYWRkaW5nLXRoZW1lcwojCiMgRXhhbXBsZToKCiNQUk9NUFQ9IiV7JGZnW3JlZF0lfSVuJXskcmVzZXRfY29sb3IlfUAleyRmZ1tibHVlXSV9JW0gJXskZmdbeWVsbG93XSV9JX4gJXskcmVzZXRfY29sb3IlfSUlICIKUFJPTVBUPSIkZmdbd2hpdGVdJCAiClJQUk9NUFQ9IiV7JGZnW3JlZF0lfSVuJXskcmVzZXRfY29sb3IlfUAleyRmZ1tibHVlXSV9JW0gJXskZmdbeWVsbG93XSV9JX4gJXskcmVzZXRfY29sb3IlfSUgIgo="  | base64 -d > ${ZSH_CUSTOM}/themes/example.zsh-theme
	cp $SH_FOOT/xx.zshrc $HOME/.zshrc
}

check_os
write
