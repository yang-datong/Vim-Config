#!/bin/bash
if [ -f $HOME/.config/nvim/plugged/seoul256.vim/colors/seoul256.vim ];then
	sed -i ".bck" 's/4B4B4B/2a2a2a/' $HOME/.config/nvim/plugged/seoul256.vim/colors/seoul256.vim
else
	echo -e "\033[31mNot found seoul256.vim file\033[0m"
fi
