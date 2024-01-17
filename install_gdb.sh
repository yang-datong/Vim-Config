#!/bin/bash
set -e

replace_symbols_link(){
	file="$1"
	really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31mDon't find the $really_file\033[0m"
		exit
	fi
	if [ ! -h "$file" ];then
		if [ -f "$file" ];then
			local date=$(date +"%Y%m%d%H%M%S")
			mv $file "/tmp/$(basename $file)_$date"
		fi
		ln -s $really_file $file
		echo -e "\033[31mReplace $file done~\033[0m"
	fi
}

#Checkout is install
check_cmd(){
    local obj=$1
    local cmd=$2
    if [ ! -x "$(command -v $obj)" ];then
        echo "$obj installing ....."
        brew install $cmd
    fi
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") cc="brew";;
	"Linux") cc="sudo apt -y";;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os
check_cmd gdb gdb

git clone https://github.com/scwuaptx/Pwngdb.git $HOME/.pwngdb
replace_symbols_link "$HOME/.gdbinit"        "$(pwd)/xx.gdbinit"
replace_symbols_link "$HOME/.gdbinit-gef.py" "$(pwd)/xx.gdbinit-gef.py"
replace_symbols_link "$HOME/.gef.rc"         "$(pwd)/xx.gef.rc"
