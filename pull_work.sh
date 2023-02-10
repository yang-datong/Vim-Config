#!/bin/bash

#set -x -v -e

echo "确定要拉取吗？会覆盖原来的文件! [y/n]"

read is_ok

function save(){
	pushd ~/Library/Mobile\ Documents/com~apple~CloudDocs
	cp -rv ./sh_foot/init.vim ~/.config/nvim/init.vim
	cp -rv ./sh_foot/markdown.snippets ~/.config/nvim/plugged/vim-snippets/UltiSnips/markdown.snippets
	cp -rv ./demo1 ~/Desktop/
	popd
	echo -e "\033[31m[🍺##########Done#############]"
}


if [ $is_ok = 'y' ];then
	save
fi


