#!/bin/bash

set -e

brew install dbus && brew services start dbus
brew tap zegervdv/zathura
brew install girara --HEAD
brew install zathura --HEAD --with-synctex

#  此时直接使用的话报错：
#  zathura ./AV音视频.pdf
#error: could not open plugin directory: /opt/homebrew/Cellar/zathura/0.5.2/lib/zathura
#error: Found no plugins. Please install at least one plugin.
#error: Could not determine file type.

#For poppler:
brew install zathura-pdf-poppler 
if [ -d $(brew --prefix zathura)/lib/zathura ];then
	mkdir -p $(brew --prefix zathura)/lib/zathura  #/opt/homebrew/opt/zathura/lib/zathura
fi

ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib
