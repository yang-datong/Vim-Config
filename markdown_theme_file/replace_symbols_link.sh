#!/bin/bash
set -e 
replace_symbols_link(){
	file="$1"
	really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31m Don't find the $really_file\033[0m"
		exit
	fi
	if [[ -h "$file" || -f "$file" ]];then
		local date=$(date +"%Y%m%d%H%M%S")
		mv $file "/tmp/$(basename $file)_$date"
		ln -s $really_file $file
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		ln -s $really_file $file
		#echo -e "\033[31m Not know file type -> $file \033[0m"
		echo -e "\033[33m Add $file done~\033[0m"
	fi
}

replace_symbols_link "$HOME/.config/nvim/plugged/markdown-preview.nvim/app/_static/markdown.css" "$(pwd)/markdown.css"
replace_symbols_link "$HOME/.config/nvim/plugged/markdown-preview.nvim/app/_static/markdown.css" "$(pwd)/page.css"
