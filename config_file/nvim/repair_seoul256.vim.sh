#!/bin/bash
f() {
	# colors.vim 中235是窗口分割线,236是某一行（加粗）的背景色
	if [ "$(uname)" == "Darwin" ]; then
		sed -i ".bck" -e 's/9A7372/2a2a2a/' -e 's/333233/2d2d2d/' -e 's/3F3F3F/2a2a2a/' -e 's/4B4B4B/2a2a2a/' -e 's/565656/2a2a2a/' -e 's/616161/2a2a2a/' $config_file
		sed -i ".bck" -e "/'StatusLine'/s/95, 95/s:dark_fg, s:light_fg/" -e "/'StatusLine'/s/187/237/" $config_file
		sed -i ".bck" -e "/'StatusLineNC'/s/s:dark_bg + 2, s:light_bg - 2/s:dark_fg, s:light_fg/" -e "/'StatusLineNC'/s/187/237/" $config_file
		sed -i '.bak' "/StatusLineNC'/ a\\
hi StatusLineNC cterm=NONE gui=NONE
" $config_file
		sed -i '.bak' "/StatusLine'/ a\\
hi StatusLine cterm=NONE gui=NONE
" $config_file
	else
		sed -i -e 's/9A7372/2a2a2a/' -e 's/333233/2d2d2d/' -e 's/3F3F3F/2a2a2a/' -e 's/4B4B4B/2a2a2a/' -e 's/565656/2a2a2a/' -e 's/616161/2a2a2a/' $config_file

		sed -i "/StatusLine'/a hi StatusLine cterm=NONE gui=NONE" $config_file
		sed -i "/StatusLineNC'/a hi StatusLine cterm=NONE gui=NONE" $config_file

		#公司的这台ubuntu25需要这样做：
		#sed -i "/StatusLine'/a hi StatusLine cterm=bold,reverse gui=bold,reverse" $config_file
		#sed -i "/StatusLineNC'/a hi StatusLineNC cterm=bold,reverse gui=bold,reverse" $config_file
	fi
}

#lazy.nvim
config_file="$HOME/.config/nvim/plugged/seoul256.vim/colors/seoul256.vim"
if [ -f $config_file ]; then f; fi

#vim-plug
config_file="$HOME/.local/share/nvim/lazy/seoul256.vim/colors/seoul256.vim"
if [ -f $config_file ]; then f; fi

#vim
config_file="$HOME/.vim/plugged/seoul256.vim/colors/seoul256.vim"
if [ -f $config_file ]; then f; fi
