#!/bin/bash

set -e

#Checkout is install
check_cmd(){
	local obj=$1
	if [ ! -x "$(command -v $obj)" ];then
		echo "$obj installing ....."
		brew install neovim
	fi
}
main(){
	#brew install neovim yarn && pip3 install pynvim
	err=$(pip3 show pynvims)
	if [ "$err" == 1 ];then	pip3 install pynvim;fi
	check_cmd nvim

	#into main work
	cd ~/.config/nvim
	cp ~/sh_foot/config_file/init.vim  ./init.vim

	err=$(echo $https_proxy)
	if [ -z "$err" ];then
		echo "export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890"
		read -p "?" ok
	fi
	#download plugins
	nvim -c "PlugInstall"

	path=$(dirname $(find . -name "c.snippets"))/
	cp ~/sh_foot/config_file/*.snippets $path

	theme="n"
	read -p "is need set markdown theme?[y/N]" theme
	if [ "$theme" == "y" ];then
		set_markdown_theme
	fi

	#cd ~/.config/nvim/plugins/markdown-preview.nvim
	#yarn install && yarn upgrade
}

set_markdown_theme(){
	file="${HOME}/.config/nvim/plugged/markdown-preview.nvim/app/_static"
  cp ./markdown_theme_file/markdown.css $file/markdown.css
	cp ./markdown_theme_file/page.css $file/page.css
}

main
#set_markdown_theme
