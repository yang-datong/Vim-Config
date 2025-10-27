#!/bin/bash
set -e
ME=$HOME
TMP=/tmp

main() {
	if [ "$(uname)" == "Darwin" ]; then
		replace_symbols_link "$ME/.config/fish/config.fish" "$SH_FOOT/config_file/shell/macos_config.fish"
		replace_symbols_link "$ME/.bashrc" "$SH_FOOT/config_file/shell/macos_xx.bashrc"
		replace_symbols_link "$ME/.zshrc" "$SH_FOOT/config_file/shell/macos_xx.zshrc"
	elif [ "$(uname)" == "Linux" ]; then
		replace_symbols_link "$ME/.config/fish/config.fish" "$SH_FOOT/config_file/shell/ubuntu_config.fish"
		replace_symbols_link "$ME/.bashrc" "$SH_FOOT/config_file/shell/ubuntu_xx.bashrc"
		replace_symbols_link "$ME/.zshrc" "$SH_FOOT/config_file/shell/ubuntu_xx.zshrc"
	fi
	replace_symbols_link "$ME/.common_aliases.sh" "$SH_FOOT/config_file/shell/xx.common_aliases.sh"

	if [ -f /.dockerenv ]; then
		replace_symbols_link "$ME/.config/fish/functions/fish_prompt.fish" "$SH_FOOT/config_file/shell/fish_prompt_docker.fish"
	else
		replace_symbols_link "$ME/.config/fish/functions/fish_prompt.fish" "$SH_FOOT/config_file/shell/fish_prompt.fish"
	fi

	replace_symbols_link "$ME/.config/nvim/filetype.vim" "$SH_FOOT/config_file/nvim/filetype.vim"
	replace_symbols_link "$ME/.clang-format" "$SH_FOOT/config_file/xx.clang-format"
	replace_symbols_link "$ME/.clangd" "$SH_FOOT/config_file/xx.clangd"

	#vim
	replace_symbols_link "$ME/.vimrc" "$SH_FOOT/config_file/nvim/xx.vimrc"
	#neovim
	replace_symbols_link "$ME/.config/nvim/init.vim" "$SH_FOOT/config_file/nvim/init.vim"
	replace_symbols_link "$ME/.config/nvim/yj.lua" "$SH_FOOT/config_file/nvim/yj.lua"
	replace_symbols_link "$ME/.config/nvim/coc-settings.json" "$SH_FOOT/config_file/nvim/coc-settings.json"
	replace_symbols_link "$ME/.config/nvim/function.vim" "$SH_FOOT/config_file/nvim/function.vim"
	replace_symbols_link "$ME/.config/nvim/unite_extension.vim" "$SH_FOOT/config_file/nvim/unite_extension.vim"

	if [ ! -d $ME/.config/nvim/lua ]; then
		mkdir $ME/.config/nvim/lua
	fi
	replace_symbols_link "$ME/.config/nvim/lua/lazy.lua" "$SH_FOOT/config_file/nvim/lua/lazy.lua"
	replace_symbols_link "$ME/.config/nvim/lua/plugins.lua" "$SH_FOOT/config_file/nvim/lua/plugins.lua"

	for file in snippets/*.snippets; do
		file_name=$(basename $file)
		#FIXME:之前vim-plug的目录
		replace_symbols_link "$ME/.config/nvim/plugged/vim-snippets/UltiSnips/$file_name" "$SH_FOOT/config_file/$file"
		#FIXME:目前lazy.nvim的目录
		#replace_symbols_link "$ME/.local/share/nvim/lazy/vim-snippets/UltiSnips/$file_name" "$SH_FOOT/config_file/$file"
	done
}

replace_symbols_link() {
	local file="$1"
	local really_file="$2"
	if [ ! -f "$really_file" ]; then
		echo -e "\033[31m Don't find the $really_file\033[0m"
		exit
	fi
	if [[ -L "$file" ]] || [[ -f "$file" ]]; then
		local date=$(date +"%Y%m%d%H%M%S")
		mv $file "$TMP/$(basename $file)_$date"
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		mkdir -p $(dirname $file)
		echo -e "\033[33m Add $file done~\033[0m"
	fi
	ln -s $really_file $file
}

if [ ! $SH_FOOT ]; then
	echo -e "\033[31m未定义\$SH_FOOT\033[0m"
	exit
fi

main
