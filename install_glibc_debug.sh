#!/bin/bash

set -ex
#如果是编译本机的，那么使用ldd --version | grep ldd，看版本

version=2.39


get_package(){
	#大约30Mb大小
	if [ ! -f glibc-${version}.tar.gz ];then
		wget http://ftp.gnu.org/gnu/libc/glibc-${version}.tar.gz
	fi

	if [ ! -d glibc-${version} ];then
		tar -xvf glibc-${version}.tar.gz
	fi


	if [ ! -x "$(command -v bison)" ];then
		sudo apt install bison -y
	fi
}



run(){
	cd glibc-${version}

	if [ -d build ];then
		rm -rf build
	fi

	mkdir build && cd build

	# 配置构建，指定安装目录
	../configure --prefix=$HOME/glibc-${version} --enable-debug --disable-werror

	make clean -j$(nproc)

	make -j$(nproc) CFLAGS="-U_FORTIFY_SOURCE -O2 -fno-stack-protector" && make install
}

build(){
	get_package
	run
}

download(){
	sudo apt-get install libc-dbg glibc-source 
	#1. 默认情况下libc-dbg会安装到 /usr/lib/debug目录下，但是我使用Ubuntu24.04并没找到，使用find / 也没有找到，奇怪
	#2. 源代码会在/usr/src/glibc/glibc-2.39.tar.xz （2.39是根据你的系统版本自动获取的）
	cd /usr/src/glibc
	local glibc_tar=$(find /usr/src -name "glibc-*.tar.xz")
	sudo tar -xf ${glibc_tar}
	echo "Use for GDB: (gdb)> directory ${glibc_tar}"
}


#build #手动编译的方式，但是编译后，使用gdb的时候会报错
download #直接下载现有的包

