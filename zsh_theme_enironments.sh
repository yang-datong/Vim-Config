#!/bin/sh

set +eux

sudo apt install gcc gdb vim vim-gtk zsh  curl git wget 

chsh -s /usr/bin/zsh 

path=${HOME}

file=$path'/.oh-my-zsh'
if [ ! -d "$file" ]; then
 git clone https://github.com/ohmyzsh/ohmyzsh.git $file 
 cp ${file}/templates/zshrc.zsh-template ~/.zshrc 
fi

file=$path'/autojump'
if [ ! -d "$file" ]; then
  git clone https://github.com/wting/autojump.git $file
  cd $file 
  ./install.py
fi

file=$path'/.oh-my-zsh/custom/plugins/zsh-autosuggestions'
if [ ! -d "$file" ]; then
git clone https://github.com/zsh-users/zsh-autosuggestions $file 
fi

file=$path'/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting'
if [ ! -d "$file" ]; then
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $file 
fi

cp ~/sh_fot/.zshrc ~/ 

