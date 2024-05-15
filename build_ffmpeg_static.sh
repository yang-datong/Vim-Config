#!/bin/bash
set -e

ScriptVersion="1.0"

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
		fetch_x264_static
		fetch_x265_static
	elif [ "$shared" == "1" ];then
		#Install x264 x265 depend(shared library)
		#apt install libx264-dev libx265-dev
		read -p "Are you already installed libx264-dev?[Y/n]" ok
		if [ "$ok" == "n" ];then exit;fi
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
	popd
}

build_ff(){
	pushd $HOME/$ff_version

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
	# 如果开启了libx265 会一直报错：ERROR: x265 not found using pkg-config，很奇怪
	./configure --prefix=$(pwd)/build \
		--extra-cflags="-static -I${HOME}/${x264_version}/build/include -O0 -g -ggdb" \
		--extra-ldflags="-static -L${HOME}/${x264_version}/build/lib -lx264" \
		--pkg-config-flags="--static" \
		--enable-small \
		--enable-gpl --enable-libx264  \
		--enable-protocol=tcp --enable-protocol=udp --enable-protocol=rtp --enable-demuxer=rtsp \
		--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
		--disable-ffplay --disable-ffprobe \
		--disable-avdevice --disable-swresample --disable-postproc \
		--disable-asm --disable-mmx --disable-sse --disable-avx --disable-vfp --disable-neon --disable-inline-asm --disable-x86asm --disable-mipsdsp \
		--enable-debug=3 --disable-optimizations --ignore-tests=TESTS
	}

	fetch_x264_static(){
		x264_version="x264-master"
		x264="x264-master.tar.bz2"
		pushd $HOME

		if [ ! -d "$x264_version" ];then
			if [ ! -f "$x264" ];then wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2;fi
			tar -xjvf $x264
		fi

		cd $x264_version
		if [ ! -f "./build/lib/libx264.a" ];then
			./configure --enable-static --disable-asm --prefix=$(pwd)/build --disable-opencl
			make -j16 && make install
		fi
		popd
	}

	fetch_x265_static(){
		x265_version="x265_3.6"
		x265="x265_3.6.tar.gz"
		pushd $HOME

		if [ ! -d "$x265_version" ];then
			if [ ! -f "$x265" ];then
				wget https://bitbucket.org/multicoreware/x265_git/downloads/${x265} -O $x265
			fi
			tar -xvf $x265
		fi

		cd $x265_version/build/linux
		if [ ! -f  $x265_version/build/linux/libx265.a ];then
			cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DENABLE_SHARED=OFF  ../../source
			make -j16 && sudo make install
		fi
		popd
	}


	confg_shared(){
		#使用动态库：
		#1.删除 --extra-cflags="-static" --extra-ldflags="-static" \
		#2.添加 --enable-shared \

		./configure \
			--prefix=$(pwd)/build \
			--enable-shared \
			--enable-small \
			--disable-doc --disable-htmlpages --disable-manpages --disable-podpages --disable-txtpages \
			--disable-ffplay --disable-ffprobe \
			--disable-avdevice --disable-swresample --disable-postproc \
			--enable-protocol=tcp --enable-protocol=udp --enable-protocol=rtp --enable-demuxer=rtsp \
			--disable-asm --disable-mmx --disable-sse --disable-avx --disable-vfp --disable-neon --disable-inline-asm --disable-x86asm --disable-mipsdsp \
			--enable-debug=3 --disable-optimizations --ignore-tests=TESTS
					--enable-gpl --enable-libx264 #--enable-libx265
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
