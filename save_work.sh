#!/bin/bash

#set -x -v  -e

echo "确定要保存吗？会覆盖原来的文件! [y/n]"
read is_ok

function save(){
	pushd ~/Library/Mobile\ Documents/com~apple~CloudDocs
	cp -vr ~/Desktop/demo1 ./  #save demo1
	cp -vr ~/.config/nvim/init.vim  ./sh_foot/  #save nvim config
	cp -vr ~/.config/nvim/plugged/vim-snippets/UltiSnips/markdown.snippets  ./sh_foot/  #save markdown.snippets
	popd
	echo -e "\033[31m[🍺!!!!!!!!!!!Done!!!!!!!!!!!]"
}

if [ $is_ok = 'y' ];then
	save
else
	exit
fi
