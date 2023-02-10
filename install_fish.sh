#!/bin/bash

function write(){
	brew install fish
	curl -L https://get.oh-my.fish | fish
	omf install aight
	omf install autojump
	pip install trash-cli #install rm foo -> mv foot foot-bck
	brew install bat
	brew install colordiff

	cp ./config_file/config.fish ~/.config/fish/config.fish
	cp ./config_file/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
}

if [ ! -x "$(command -v fish)" ];then
	write
fi
