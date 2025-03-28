#!/bin/bash
set -e

ubuntu(){
	check_cmd gdb gdb
	if [ ! -d $HOME/.pwngdb ];then
		git clone https://github.com/scwuaptx/Pwngdb.git $HOME/.pwngdb
	fi

	replace_symbols_link "$HOME/.gdbinit"         "$SH_FOOT/config_file/gdb/xx.gdbinit"
	replace_symbols_link "$HOME/.gdbinit-gef.py"  "$SH_FOOT/config_file/gdb/xx.gdbinit-gef.py"
	replace_symbols_link "$HOME/.gef.rc"          "$SH_FOOT/config_file/gdb/xx.gef.rc"
	replace_symbols_link "$HOME/.hide_command.py" "$SH_FOOT/config_file/gdb/xx.hide_command.py"
}

macos(){
	#if [ ! -d $HOME/.voltron ];then
		#git clone https://github.com/snare/voltron $HOME/.voltron
		#pushd $HOME/.voltron
		#./install.sh
		#popd
	#else
		#echo -e "\033[31mInstalled??? Try to exec 'cd $HOME/.voltron && ./install.sh'\033[0m";exit
	#fi
	if [ ! -d $HOME/.llef ];then
		git clone https://github.com/foundryzero/llef.git $HOME/.llef
	fi
	replace_symbols_link "$HOME/.lldbinit"        "$SH_FOOT/config_file/gdb/xx.lldbinit"
}

replace_symbols_link(){
	local file="$1"
	local really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31m Don't find the $really_file\033[0m"; exit
	fi
	if [[ -h "$file" ]] || [[ -f "$file" ]];then
		local date=$(date +"%Y%m%d%H%M%S")
		mv $file "/tmp/$(basename $file)_$date"
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		echo -e "\033[33m Add $file done~\033[0m"
	fi
		ln -s $really_file $file
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";macos;;
		"Linux") cc="sudo apt -y";ubuntu;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
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



check_os
