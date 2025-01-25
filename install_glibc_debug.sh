#!/bin/bash
set -e
#如果是编译本机的，那么使用ldd --version | grep ldd，看版本

#注意，某些版本下载是无法下载到对应的版本的，需要看你使用的镜像源是否具有这个包，而有的镜像是直接返回了一个相近版本的glibc，比如下载glibc-2.28但实际上apt下载的是glibc-2.27
version=2.39

build(){
	get_package
	run
}

download(){
	sudo apt install libc-dbg  #下载glibc的调试符号（调试符号是剥离的）
	sudo apt install glibc-source #下载glibc源代码
	#注意，上面两个都需要安装， 少了一个都会导致无法正确调试源代码

	#1. 默认情况下libc-dbg会安装到 /usr/lib/debug/.build-id 目录下（具体可以通过dpkg -L libc6-dbg查看），
	#2. 源代码会在/usr/src/glibc/glibc-2.39.tar.xz （2.39是根据你的系统版本自动获取的）
	cd /usr/src/glibc
	local glibc_tar=$(find /usr/src -type f -name "glibc-*.tar.xz")
	local glibc_dir=$(find /usr/src -type d -name "glibc-*")
	sudo tar -xf ${glibc_tar}
	echo "Use for GDB: (gdb)> directory ${glibc_dir}"
}

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
		#重新编译
		rm -rf build
	fi
	mkdir build && cd build

	# 配置构建，指定安装目录（无法关闭静态库的编译，只能关闭动态库）
	../configure --prefix=$HOME/glibc-${version} --enable-debug --disable-werror --host=x86_64-linux-gnu
	make clean -j$(nproc)
	make -j$(nproc) CFLAGS="-U_FORTIFY_SOURCE -Og -g3 -fno-stack-protector" && make install
	#NOTE: Glibc不允许编译时，完全关闭优化，比如-O0，这会报错：
	#./../include/libc-symbols.h:75:3: error: #error "glibc cannot be compiled without optimization" 75 | # error "glibc cannot be compiled without optimization"
	#NOTE: 不需要进行-fno-inline-functions刻意的关闭掉内联，-Og已经提供了很好的调试环境


	echo -e "\033[33m
	编译文件已输出在$HOME/glibc-${version}，注意！使用方式如下（下面两种方式都可以）：
	1. 编译时手动替换系统路径下的libc.so: g++ -Wl,--rpath=$HOME/glibc-${version}/lib/ demo.cpp
	2. apt install patchelf && patchelf --set-rpath $HOME/glibc-${version}/lib a.out

	最后通过ldd查看二进制文件链接是否为自己编译路径的libc.so.6\033[0m"

#在高版本Ubuntu中，不需要设置ld的链接路径，如：
#patchelf --set-interpreter $HOME/glibc-2.39/lib/ld-linux-x86-64.so.2 --set-rpath $HOME/glibc-2.39/lib a.out
#只需要指定libc.so即可（手动编译的时候同理，如果强行加上ld.so反而会报错其他链接库问题）:
#patchelf --set-rpath $HOME/glibc-2.39/lib a.out

#编译时间大概为4-5分钟
#	________________________________________________________
# Executed in  229.82 secs    fish           external
#   usr time  581.83 secs    0.00 micros  581.83 secs
#   sys time  280.24 secs  487.00 micros  280.24 secs

	#$ g++ demo.cpp -Wl,--rpath=/home/hi/glibc-2.39/lib -Wl,--dynamic-linker=/home/hi/glibc-2.39/lib/ld-linux-x86-64.so.2 -g

	#$ du -sh libc.a
	#  5.9M	libc.a
	#$ du -sh libc.so.6   （具有调试符号的libc.so才2.3M，一个静态库就是两倍）
	#  2.3M	libc.so.6
}


build
#download #直接下载现有的包（不一定有对应的版本能下载到）
