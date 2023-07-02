#!/bin/zsh


	cp ./xx.vimrc $HOME/.vimrc
  sudo update-alternatives --config gcc #切换为gcc-8
	vim -c "PlugInstall"


build(){
	#安装代码提示插件
	sudo apt install g++-8
	sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 800 --slave /usr/bin/g++ g++ /usr/bin/g++-8
	sudo update-alternatives --config gcc #切换为gcc-8

	wget https://github.com/Kitware/CMake/releases/download/v3.17.1/cmake-3.17.1-linux-x86_64.tar.gz
	tar -zxvf cmake-3.17.1-linux-x86_64.tar.gz
	cd cmake-3.17.1-linux-x86_64
	sudp cp /bin/cmake /usr/bin/
	sudo cp -r share/cmake-3.17 /usr/share

	git clone https://github.com/vim/vim.git
	sudo apt-get install libncurses5-dev python-dev python3-dev libgtk3.0-cil-dev libatk1.0-dev libbonoboui2-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev
	cd vim
	sudo ./configure --with-features=huge --enable-multibyte --enable-rubyinterp --enable-pythoninterp --enable-python3interp --enable-luainterp --enable-cscope --enable-gui=gtk3 --enable-perlinterp --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ --with-python3-config-dir=/usr/lib/python3.6/config-3.6m-x86_64-linux-gnu/ --prefix=/usr/local/vim
	sudo make  #gcc version 8.4.0
	sudo make install
	sudo cp ./src/vim /usr/bin/

	#taglist插件依赖
	sudo apt-get install ctags

	#安装插件
	file = '~/.vim/bundle/YouCompleteMe'
	if [ ! -d "$file"]; then
		cd ~/.vim/bundle
		git clone https://github.com/ycm-core/YouCompleteMe.git
		git submodule update --init --recursive
		cd ~/.vim/bundle/YouCompleteMe
		python3 install.py --clang-completer
	fi
}
