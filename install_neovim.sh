#!/bin/bash

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
	sed -i '' -e 's/--color-text-primary: \#c9d1d9;/--color-text-primary:\#edeef3;/' -e 's/--color-markdown-blockquote-border: \#3b434b;/--color-markdown-blockquote-border: \#83D1DD;/' -e 's/--color-markdown-table-tr-border: \#272c32;/--color-markdown-table-tr-border: \#3b434b;/' -e 's/--color-bg-primary: \#0d1117;/--color-bg-primary: \#393939;/' -e '/line-height: 1.4;/a\
		color: #83D1DD;' $file/markdown.css
	num=$(grep -n "table tr:nth-child" ${file}/markdown.css | awk -F ":" '{print $1}')
	num=$[$num+1]
	sed -i '' -e ${num}d  -e '/table tr:nth-child/a\
  background-color: var(--color-bg-primary);' $file/markdown.css
	sed -i '' 's/181a1b/393939/' $file/page.css
}

main
