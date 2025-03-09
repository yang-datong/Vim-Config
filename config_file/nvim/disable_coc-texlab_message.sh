#!/bin/bash

file=$HOME/.config/coc/extensions/node_modules/coc-texlab/lib/index.js

if [ ! -f $file ]; then
	echo "File not found!"
	exit
fi

if [ $(uname) == "Darwin" ]; then
	sed -i .bck 's/import_coc3.window.showInformationMessage(`TexLab Server Started`);/\/\/import_coc3.window.showInformationMessage(`TexLab Server Started`);/' $file
elif [ $(uname) == "Linux" ]; then
	sed -i 's/import_coc3.window.showInformationMessage(`TexLab Server Started`);/\/\/import_coc3.window.showInformationMessage(`TexLab Server Started`);/' $file
else
	exit
fi
