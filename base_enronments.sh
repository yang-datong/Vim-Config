#!/bin/bash

#Check OS System
if [ "$(uname)" == "Linux" ];then
	sudo apt install -y ncurses file sudo passwd
fi

./install_aria2c.sh
./install_fish.sh
./install_neovim.sh

./tools/replace_symbols_link.sh
./config_file/replace_symbols_link.sh
