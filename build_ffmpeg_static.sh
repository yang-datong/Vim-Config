#!/bin/bash
set -e

ScriptVersion="1.0"
work_dir=$(pwd)

unset file
unset directory

ff_version="ffmpeg-4.2.2"
ff="${ff_version}.tar.bz2"

static=1
shared=0

main(){
	confirmation_info
	download_ffmpeg
	if [ "$static" == "1" ];then
		fetch_x264_lib static
		fetch_x265_lib static
	elif [ "$shared" == "1" ];then
		echo -e "\033[31m还有点问题，可以编译，但是不能运行\033[0m"
		fetch_x264_lib shared
		fetch_x265_lib shared
		#Install x264 x265 depend(shared library)
		#dpkg -L libx264-dev || sudo apt install libx264-dev 这种方式没有调试符号
		#dpkg -L libx265-dev || sudo apt install libx265-dev
		#read -p "Are you already installed libx264-dev/libx265-dev?[Y/n]" ok
		#if [ "$ok" == "n" ];then exit;fi
		echo "IyEvYmluL2Jhc2gKCmV4cG9ydCBMRF9MSUJSQVJZX1BBVEg9bGliYXZjb2RlYzpsaWJhdmRldmljZTpsaWJhdmZpbHRlcjpsaWJhdmZvcm1hdDpsaWJhdnJlc2FtcGxlOmxpYmF2dXRpbDpsaWJwb3N0cHJvYzpsaWJzd3Jlc2FtcGxlOmxpYnN3c2NhbGU6Li4veDI2NV8zLjYvYnVpbGQvbGludXg6Li4veDI2NC1tYXN0ZXIvCgpnZGIgZmZtcGVnX2cgXAoJLWV4ICJkaXJlY3RvcnkgbGliYXZjb2RlYzpsaWJhdmRldmljZTpsaWJhdmZpbHRlcjpsaWJhdmZvcm1hdDpsaWJhdnJlc2FtcGxlOmxpYmF2dXRpbDpsaWJwb3N0cHJvYzpsaWJzd3Jlc2FtcGxlOmxpYnN3c2NhbGUiIFwKCS1leCAic2V0IGFyZ3MgLWkgZGVtby5tcDQgZGVtby5oMjY0IC15IiBcCgktZXggImIgbWFpbiIgXAoJLWV4ICJyIgo=" | base64 -d > $work_dir/$ff_version/gdb.sh | chmod +x $work_dir/$ff_version/gdb.sh
	else
		exit
	fi
	build_ff
}

confirmation_info(){
	local tips="Static"
	if [ "$static" == "1" ];then
		tips="Static"
	elif [ "$shared" == "1" ];then
		tips="Dynamic"
	fi
	echo -e "\033[31m${tips} compilation will be used. continue?[Y/n]\033[0m"
	read ok
	if [ "$ok" == "n" ];then
		echo -e "\033[31mTry --help\033[0m"
		exit
	fi
}

download_ffmpeg(){
	pushd $work_dir
	if [ ! -d $ff_version ];then
		if [ ! -f "$ff" ];then wget https://ffmpeg.org/releases/$ff;fi
		tar -xjvf $ff
	fi
	popd

	pushd $work_dir/$ff_version
	if [ -f "Changelog" ];then
		rm Changelog *.md COPYING.* CREDITS MAINTAINERS RELEASE* VERSION
	fi
	popd
}

build_ff(){
	pushd $work_dir/$ff_version

	local ret=$(find . -name "*.o")
	if [ -n "$ret" ];then
		echo "make clean..."
		make -j16 clean
	fi

	if [ "$static" == "1" ];then
		confg_static
	elif [ "$shared" == "1" ];then
		confg_shared
	fi

	make -j16 && make install
	popd
}

confg_static(){
	# 如果开启了 --enable-libx265 会一直报错：ERROR: x265 not found using pkg-config，因为默认是引用动态库，只需要自己在flags中指定那么也可以链接到x265，x265 使用了 dlopen 函数，而 dlopen 是用来打开动态链接库的。 在静态链接的应用程序中使用 dlopen 通常会导致问题， 因为静态链接的目的是将所有代码都包含在可执行文件中，而不需要额外的库，所以不能静态链接到x265
	# -Wdeprecated-declarations 不打印函数过时的警告
	export PKG_CONFIG_PATH=${work_dir}/${x265_version}/build/linux:${HOME}/${x264_version}/build/lib/pkgconfig

	#不要用-ggdb，-g3就是最高调试级别，-ggdb反而没有这么多调试信息
	./configure --prefix=$(pwd)/build \
		--extra-cflags="-static -O0 -g3 -Wno-deprecated-declarations" --extra-ldflags="-static" --pkg-config-flags="--static" \
		--enable-small \
		--enable-gpl --enable-libx264 \
		--enable-protocol=tcp --enable-protocol=udp --enable-protocol=rtp --enable-demuxer=rtsp \
		--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
		--disable-ffplay --disable-ffprobe \
		--disable-avdevice --disable-swresample --disable-postproc \
		--disable-asm --disable-mmx --disable-sse --disable-avx --disable-vfp --disable-neon --disable-inline-asm --disable-x86asm --disable-mipsdsp \
		--enable-debug=3 --disable-optimizations --ignore-tests=TESTS
}

confg_shared(){
	#使用动态库：
	#1.删除 --extra-cflags="-static" --extra-ldflags="-static" \
	#2.添加 --enable-shared \
	export PKG_CONFIG_PATH=${work_dir}/${x265_version}/build/linux:${HOME}/${x264_version}/build/lib/pkgconfig
	./configure \
		--prefix=$(pwd)/build \
		--extra-cflags="-O0 -g3 -Wno-deprecated-declarations" \
		--enable-shared --disable-static \
		--enable-small \
		--enable-gpl --enable-libx264 --enable-libx265 \
		--enable-protocol=tcp --enable-protocol=udp --enable-protocol=rtp --enable-demuxer=rtsp \
		--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
		--disable-ffplay --disable-ffprobe \
		--disable-avdevice --disable-swresample --disable-postproc \
		--enable-protocol=tcp --enable-protocol=udp --enable-protocol=rtp --enable-demuxer=rtsp \
		--disable-asm --disable-mmx --disable-sse --disable-avx --disable-vfp --disable-neon --disable-inline-asm --disable-x86asm --disable-mipsdsp \
		--enable-debug=3 --disable-optimizations --ignore-tests=TESTS
	}

fetch_x264_lib(){
	local type="$1"
	x264_version="x264-master"
	x264="x264-master.tar.bz2"
	pushd $work_dir

	if [ ! -d "$x264_version" ];then
		if [ ! -f "$x264" ];then wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2;fi
		tar -xjvf $x264
	fi

	cd $x264_version
	if [ "$type" == "static" ];then
		if [ ! -f "./build/lib/libx264.a" ];then
			./configure --enable-static --disable-asm --prefix=$(pwd)/build --disable-opencl --disable-cli  --enable-debug --extra-cflags="-g3 -O0" --extra-ldflags="-static"
			#--enable-static: 启用静态库的构建。
			#--disable-asm: 禁用汇编代码优化。
			#--disable-cli: 禁用 x264 命令行工具的构建。
			#--disable-opencl: 禁用 OpenCL 支持。
			#--disable-avs, --disable-lavf, --disable-swscale: 禁用其他库的依赖。
			#--disable-strip: 禁用从可执行文件和库中删除调试符号。
			#--extra-cflags="-g -O0": 添加编译器选项:
			#-g: 包含调试信息.
			#-O0: 禁用所有代码优化。
			#--extra-ldflags="-static": 添加链接器选项:
			#-static: 使用静态链接。
			make -j16 && make install
		fi
	elif [ "$type" == "shared" ];then
		./configure --enable-shared --disable-asm --disable-opencl --disable-cli  --enable-debug --extra-cflags="-g3 -O0"
		make -j16 && sudo make install
	else
		echo -e "\033[31mfetch_x264_lib failed\033[0m";exit
	fi
	popd
}

fetch_x265_lib(){
	local type="$1"
	x265_version="x265_3.6"
	x265="x265_3.6.tar.gz"
	pushd $work_dir

	if [ ! -d "$x265_version" ];then
		if [ ! -f "$x265" ];then
			wget https://bitbucket.org/multicoreware/x265_git/downloads/${x265} -O $x265
		fi
		tar -xvf $x265
	fi

	cd $x265_version/build/linux
	if [ "$type" == "static" ];then
		if [ ! -f  libx265.a ];then
			cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=${work_dir}/${x265_version}/build/linux/lib -DCMAKE_BUILD_TYPE=Debug -DENABLE_SHARED=OFF -DENABLE_CLI=OFF -DHIGHBITDEPTH=OFF -DASM=OFF -DEXTRA_CFLAGS="-g3 -O0" -DEXTRA_LDFLAGS="-static" ../../source
			#-DENABLE_CLI=OFF: 禁用 x265 命令行工具的构建。
			#-DHIGHBITDEPTH=OFF: 禁用高比特深度支持 (可选)。
			make -j16 && make install
		fi
	elif [ "$type" == "shared" ];then
		cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -DENABLE_CLI=OFF -DHIGHBITDEPTH=OFF -DASM=OFF -DEXTRA_CFLAGS="-g3 -O0" ../../source
		make -j16 && sudo make install
	else
		echo -e "\033[31mfetch_x265_lib failed\033[0m";exit
	fi
	popd
}


usage (){
	echo "Usage :  $(basename "$0") [options] [--] argument-1 argument-2

	Options:
	-h, --help                  Display this message
	-d, --debug                 Debug model run
	-p, --posix                 Posix model parse shell command
	-v, --version               Display script version
	-f, --file FILE             Target file
	-D, --directory DIRECTORY   Target directory
	--static                    Static compilation ffmpeg components and static link(default)
	--shared                    Dynamic compilation ffmpeg components and dynamic link
	--build_ffmpeg              Separate compilation ffmpeg"
}

while getopts ":hdpvf:D:-:" opt; do
	case "${opt}" in
		h) usage && exit 0;;
		d) set -x ;;
		p) set -o posix ;;
		v) echo "$0 -- Version $ScriptVersion"; exit ;;
		f) file=${OPTARG};;
		D) directory=${OPTARG};;
		-) case "${OPTARG}" in
			help) usage && exit 0;;
			debug)      set -x ;;
			posix)      set -o posix ;;
			version)    echo "$0 -- Version $ScriptVersion"; exit ;;
			file)       file=${!OPTIND}; OPTIND=$((OPTIND+1));;
			directory)  directory=${!OPTIND}; OPTIND=$((OPTIND+1));;
			static)     static=1;shared=0;;
			shared)     shared=1;static=0;;
			build_ffmpeg)build_ff ;exit;;
			*)          echo "Invalid option: --${OPTARG}" >&2 && exit 1;;
		esac;;
	:) echo "Option -${OPTARG} requires an argument." >&2 && exit 1;;
	*) echo "Invalid option: -${OPTARG}" >&2 && exit 1;;
	esac
done
shift $((OPTIND-1))

main "$@"
