#!/bin/bash

#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") cc=bt;;
	"Linux") ;;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}
if [ "$(uname)" == "Linux" ];then
	apt install -y ncurses file sudo passwd
fi

install_aria2c.sh
install_fish.sh
install_neovim.sh

./tools/replace_symbols_link.sh
./config_file/replace_symbols_link.sh
