#!/bin/bash
set -e

#Ubuntu使用GEF更好
ubuntu() {
	check_cmd gdb gdb
	if [ ! -d $HOME/.pwngdb ]; then
		git clone https://github.com/scwuaptx/Pwngdb.git $HOME/.pwngdb
	fi

	replace_symbols_link "$HOME/.gdbinit" "$SH_FOOT/config_file/gdb/xx.gdbinit"
	replace_symbols_link "$HOME/.gdbinit-gef.py" "$SH_FOOT/config_file/gdb/xx.gdbinit-gef.py"
	replace_symbols_link "$HOME/.gef.rc" "$SH_FOOT/config_file/gdb/xx.gef.rc"
	replace_symbols_link "$HOME/.hide_command.py" "$SH_FOOT/config_file/gdb/xx.hide_command.py"
}

#NOTE: MacOS无法使用gdb（高版本下），会报错：Unable to find Mach task port for process-id 861: (os/kern) failure (0x5).
macos() {
	macos_for_llef
	#macos_for_voltron
	#macos_for_pwndbg
}

#MacOS无法使用GEF，但有一个仿照GEF的项目LLEF
macos_for_llef() {
	if [ ! -d $HOME/.llef_lldb ]; then
		git clone https://github.com/foundryzero/llef.git $HOME/.llef_lldb
	fi
	if [ "$(arch)" == "arm64" ]; then
		replace_symbols_link "$HOME/.lldbinit" "$SH_FOOT/config_file/gdb/xx.lldbinit_arm"
	else
		replace_symbols_link "$HOME/.lldbinit" "$SH_FOOT/config_file/gdb/xx.lldbinit_x86"
	fi
	replace_symbols_link "$HOME/.llef" "$SH_FOOT/config_file/gdb/xx.llef"
}

macos_for_voltron() {
	if [ ! -d $HOME/.voltron ]; then
		git clone https://github.com/snare/voltron $HOME/.voltron
		pushd $HOME/.voltron
		./install.sh
		popd
	else
		echo -e "\033[31mInstalled??? Try to exec 'cd $HOME/.voltron && ./install.sh'\033[0m"
		exit
	fi
}

#MacOS使用Pwndbg-lldb
macos_for_pwndbg() {
	#For GDB
	#brew install pwndbg/tap/pwndbg-gdb
	#For LLDB
	brew install pwndbg/tap/pwndbg-lldb
}

replace_symbols_link() {
	local file="$1"
	local really_file="$2"
	if [ ! -f "$really_file" ]; then
		echo -e "\033[31m Don't find the $really_file\033[0m"
		exit
	fi
	if [[ -L "$file" ]] || [[ -f "$file" ]]; then
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

#Checkout is install
check_cmd() {
	local obj=$1
	local cmd=$2
	if [ ! -x "$(command -v $obj)" ]; then
		echo "$obj installing ....."
		brew install $cmd
	fi
}

check_os
