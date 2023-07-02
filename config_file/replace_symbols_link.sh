#!/bin/bash
set -e

#replace_symbols_link(){
#	file="$1"
#	really_file="$2"
#	if [ ! -f "$really_file" ];then
#		echo -e "\033[31mDon't find the $really_file\033[0m"
#		exit
#	fi
#	if [ ! -h "$file" ];then
#		if [ -f "$file" ];then
#			local date=$(date +"%Y%m%d%H%M%S")
#			mv $file "/tmp/$(basename $file)_$date"
#		fi
#		ln -s $really_file $file
#		echo -e "\033[31mReplace $file done~\033[0m"
#	fi
#}

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


replace_symbols_link "$HOME/.config/nvim/filetype.vim" "$(pwd)/filetype.vim"
replace_symbols_link "$HOME/compile_flags.txt" "$(pwd)/compile_flags.txt"
replace_symbols_link "$HOME/.clang-format" "$(pwd)/xx.clang-format"
replace_symbols_link "$HOME/.bashrc" "$(pwd)/../xx.bashrc"
replace_symbols_link "$HOME/.zshrc" "$(pwd)/../xx.zshrc"

#if [ "$(uname)" == "Darwin" ];then
	replace_symbols_link "$HOME/.config/nvim/init.vim" "$(pwd)/init.vim"
	replace_symbols_link "$HOME/.config/fish/config.fish" "$(pwd)/config.fish"
#fi

for file in *.snippets;do
	replace_symbols_link "$HOME/.config/nvim/plugged/vim-snippets/UltiSnips/$file" "$(pwd)/$file"
done
