#!/bin/bash

ff_version="ffmpeg-4.2.2"
ff="${ff_version}.tar.bz2"

main(){
	pushd $HOME
	if [ ! -d $ff_version ];then
		if [ ! -f "$ff" ];then wget https://ffmpeg.org/releases/$ff;fi
		tar -xjvf $ff
	fi
	popd

	pushd $HOME/$ff_version
	if [ -f "Changelog" ];then
		rm Changelog *.md COPYING.* CREDITS MAINTAINERS RELEASE* VERSION
	fi

	build_ff
}

build_ff(){
	echo -e "\033[31mAre you already?[Y/n]\033[0m"
	read ok
	if [ "$ok" == "n" ];then exit;fi


#这里默认是是静态编译库、和静态链接
#如果要使用动态库：
#1.删除 --extra-cflags="-static" --extra-ldflags="-static" \
#2.添加 --enable-shared \
./configure \
	--prefix=$(pwd)/build \
	--extra-cflags="-static" --extra-ldflags="-static" \
	--enable-small \
	--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
	--disable-ffplay --disable-ffprobe \
	--disable-avdevice --disable-swresample --disable-swscale --disable-postproc \
	--disable-network \
	--disable-asm --disable-mmx --disable-sse --disable-avx --disable-vfp --disable-neon --disable-inline-asm --disable-x86asm --disable-mipsdsp \
	--enable-debug=3 --disable-optimizations --ignore-tests=TESTS

make -j 16 && make install
popd
}

main
