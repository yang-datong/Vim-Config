#!/bin/bash
config_file="$HOME/.config/nvim/plugged/seoul256.vim/colors/seoul256.vim"
if [ -f $config_file ]; then
	# colors.vim 中235是窗口分割线,236是某一行（加粗）的背景色
	if [ "$(uname)" == "Darwin" ]; then
		sed -i ".bck" -e 's/9A7372/2a2a2a/' -e 's/333233/2d2d2d/' -e 's/3F3F3F/2a2a2a/' -e 's/4B4B4B/2a2a2a/' -e 's/565656/2a2a2a/' -e 's/616161/2a2a2a/' $config_file
		sed -i ".bck" -e "/'StatusLine'/s/95, 95/s:dark_fg, s:light_fg/" -e "/'StatusLine'/s/187/237/" $config_file
		sed -i ".bck" -e "/'StatusLineNC'/s/s:dark_bg + 2, s:light_bg - 2/s:dark_fg, s:light_fg/" -e "/'StatusLineNC'/s/187/237/" $config_file
	else
		sed -i -e 's/9A7372/2a2a2a/' -e 's/333233/2d2d2d/' -e 's/3F3F3F/2a2a2a/' -e 's/4B4B4B/2a2a2a/' -e 's/565656/2a2a2a/' -e 's/616161/2a2a2a/' $config_file
	fi
else
	echo -e "\033[31mNot found seoul256.vim file\033[0m"
fi
