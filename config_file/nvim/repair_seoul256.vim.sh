#!/bin/bash
config_file="$HOME/.config/nvim/plugged/seoul256.vim/colors/seoul256.vim"
if [ -f $config_file ]; then
	if [ "$(uname)" == "Darwin" ]; then
		sed -i ".bck" 's/4B4B4B/2a2a2a/' $config_file
	else
		sed -i 's/4B4B4B/2a2a2a/' $config_file
	fi
else
	echo -e "\033[31mNot found seoul256.vim file\033[0m"
fi
