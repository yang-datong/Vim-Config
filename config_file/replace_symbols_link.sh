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


replace_symbols_link "$HOME/.config/nvim/filetype.vim" "$SH_FOOT/config_file/filetype.vim"
replace_symbols_link "$HOME/compile_flags.txt" "$SH_FOOT/config_file/compile_flags.txt"
replace_symbols_link "$HOME/.clang-format" "$SH_FOOT/config_file/xx.clang-format"
replace_symbols_link "$HOME/.zshrc" "$SH_FOOT/config_file/../xx.zshrc"
replace_symbols_link "$HOME/.config/nvim/init.vim" "$SH_FOOT/config_file/init.vim"
replace_symbols_link "$HOME/.config/nvim/yj.lua" "$SH_FOOT/config_file/yj.lua"
replace_symbols_link "$HOME/.config/nvim/coc-settings.json" "$SH_FOOT/config_file/coc-settings.json"
if [ "$(uname)" == "Darwin" ];then
	replace_symbols_link "$HOME/.config/fish/config.fish" "$SH_FOOT/config_file/config_macos.fish"
	replace_symbols_link "$HOME/.bashrc" "$SH_FOOT/config_file/macos_xx.bashrc"
else
	replace_symbols_link "$HOME/.config/fish/config.fish" "$SH_FOOT/config_file/config_ubuntu.fish"
	replace_symbols_link "$HOME/.bashrc" "$SH_FOOT/config_file/ubuntu_xx.bashrc"
fi

for file in *.snippets;do
	replace_symbols_link "$HOME/.config/nvim/plugged/vim-snippets/UltiSnips/$file" "$SH_FOOT/config_file/$file"
done
