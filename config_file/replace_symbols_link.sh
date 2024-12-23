#!/bin/bash
set -e

main(){
	if [ "$(uname)" == "Darwin" ];then
		replace_symbols_link "$HOME/.config/fish/config.fish"  "$SH_FOOT/config_file/shell/macos_config.fish"
		replace_symbols_link "$HOME/.bashrc"                   "$SH_FOOT/config_file/shell/macos_xx.bashrc"
	elif [ "$(uname)" == "Linux" ];then
		replace_symbols_link "$HOME/.config/fish/config.fish"  "$SH_FOOT/config_file/shell/ubuntu_config.fish"
		replace_symbols_link "$HOME/.bashrc"                   "$SH_FOOT/config_file/shell/ubuntu_xx.bashrc"
	fi
	replace_symbols_link "$HOME/.config/nvim/filetype.vim"         "$SH_FOOT/config_file/nvim/filetype.vim"
	replace_symbols_link "$HOME/.clang-format"                     "$SH_FOOT/config_file/xx.clang-format"
	replace_symbols_link "$HOME/.clangd"                           "$SH_FOOT/config_file/xx.clangd"
	replace_symbols_link "$HOME/.zshrc"                            "$SH_FOOT/config_file/shell/xx.zshrc"
	replace_symbols_link "$HOME/.config/nvim/init.vim"             "$SH_FOOT/config_file/nvim/init.vim"
	replace_symbols_link "$HOME/.config/nvim/yj.lua"               "$SH_FOOT/config_file/nvim/yj.lua"
	replace_symbols_link "$HOME/.config/nvim/coc-settings.json"    "$SH_FOOT/config_file/nvim/coc-settings.json"
	replace_symbols_link "$HOME/.config/nvim/function.vim"         "$SH_FOOT/config_file/nvim/function.vim"
	replace_symbols_link "$HOME/.config/nvim/unite_extension.vim"  "$SH_FOOT/config_file/nvim/unite_extension.vim"

	for file in snippets/*.snippets;do
		file_name=$(basename $file)
		replace_symbols_link "$HOME/.config/nvim/plugged/vim-snippets/UltiSnips/$file_name" "$SH_FOOT/config_file/$file"
	done
}

replace_symbols_link(){
	local file="$1"
	local really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31m Don't find the $really_file\033[0m"; exit
	fi
	if [[ -h "$file" ]] || [[ -f "$file" ]];then
		local date=$(date +"%Y%m%d%H%M%S")
		mv $file "/tmp/$(basename $file)_$date"
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		echo -e "\033[33m Add $file done~\033[0m"
	fi
		ln -s $really_file $file
}

if [ ! $SH_FOOT ];then
	echo -e "\033[31m未定义\$SH_FOOT\033[0m";exit
fi

main
