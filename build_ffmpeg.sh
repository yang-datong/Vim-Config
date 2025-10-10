#!/bin/bash
#set -ex
#NOTE: 最终生成的ffmpeg_g基本是-O0，但是一些系统函数还是编译为-Os，如果需要完全的-O0，则需要手动修改config.mk文件，再次重新编译

ScriptVersion="2.0"
work_dir=$(pwd)

#时候开启编译调试模式（ffmpeg、x264,x265都会带有调试符号，以及最小优化）
#debug=1
unset debug

unset file
unset directory

ff_version="ffmpeg-4.4.2"
ff="${ff_version}.tar.bz2"

x264_version="x264_0.164.5"
x264="${x264_version}.tar.bz2"
x265_version="x265_3.6"
x265="${x265_version}.tar.gz"

static=0
shared=1

is_bear=1
make="make -j16"
if [ $is_bear == 1 ]; then
	make="bear -- make -j16"
fi

#hwaccel="--enable-vaapi " #sudo apt install ffmpeg vainfo libva-dev libdrm-dev

main() {
	confirmation_info
	download_ffmpeg
	if [ "$static" == "1" ]; then
		fetch_x264_lib static
		fetch_x265_lib static
	elif [ "$shared" == "1" ]; then
		fetch_x264_lib shared
		fetch_x265_lib shared
		echo "IyEvYmluL2Jhc2gKCmV4cG9ydCBMRF9MSUJSQVJZX1BBVEg9bGliYXZjb2RlYzpsaWJhdmRldmljZTpsaWJhdmZpbHRlcjpsaWJhdmZvcm1hdDpsaWJhdnJlc2FtcGxlOmxpYmF2dXRpbDpsaWJwb3N0cHJvYzpsaWJzd3Jlc2FtcGxlOmxpYnN3c2NhbGU6Li4veDI2NV8zLjYvYnVpbGQvbGludXhfYW1kNjQvbGliLzouLi94MjY0LW1hc3Rlci9idWlsZC9saWIvCgpleHBvcnQgRFlMRF9MSUJSQVJZX1BBVEg9bGliYXZjb2RlYzpsaWJhdmRldmljZTpsaWJhdmZpbHRlcjpsaWJhdmZvcm1hdDpsaWJhdnJlc2FtcGxlOmxpYmF2dXRpbDpsaWJwb3N0cHJvYzpsaWJzd3Jlc2FtcGxlOmxpYnN3c2NhbGU6Li4veDI2NV8zLjYvYnVpbGQvbGludXhfYW1kNjQvbGliLzouLi94MjY0LW1hc3Rlci9idWlsZC9saWIvCgpnZGIgZmZtcGVnX2cgXAoJLWV4ICJkaXJlY3RvcnkgbGliYXZjb2RlYzpsaWJhdmRldmljZTpsaWJhdmZpbHRlcjpsaWJhdmZvcm1hdDpsaWJhdnJlc2FtcGxlOmxpYmF2dXRpbDpsaWJwb3N0cHJvYzpsaWJzd3Jlc2FtcGxlOmxpYnN3c2NhbGUiIFwKCS1leCAic2V0IGFyZ3MgLWkgZGVtby5tcDQgZGVtby5oMjY0IC15IiBcCgktZXggImIgbWFpbiIgXAoJLWV4ICJyIgo=" | base64 -d >$work_dir/$ff_version/gdb.sh | chmod +x $work_dir/$ff_version/gdb.sh
	else
		exit
	fi
	build_ff
}

confirmation_info() {
	local tips="Static"
	if [ "$static" == "1" ]; then
		tips="Static"
	elif [ "$shared" == "1" ]; then
		tips="Dynamic"
	fi
	echo -e "\033[31m${tips} compilation will be used. continue?[Y/n]\033[0m"
	read ok
	if [ "$ok" == "n" ]; then
		echo -e "\033[31mTry --help\033[0m"
		exit
	fi
}

download_ffmpeg() {
	pushd $work_dir
	if [ ! -d $ff_version ]; then
		if [ ! -f "$ff" ]; then wget https://ffmpeg.org/releases/$ff; fi
		tar -xjvf $ff
	fi
	popd

	pushd $work_dir/$ff_version
	if [ -f "Changelog" ]; then
		rm Changelog *.md COPYING.* CREDITS MAINTAINERS RELEASE* VERSION
	fi
	popd
}

build_ff() {
	pushd $work_dir/$ff_version

	local ret=$(find . -name "*.o")
	if [ -n "$ret" ]; then
		echo "make clean..."
		${make} clean
	fi

	#编译较小的ffmpeg、最大化便于调试、无任何优化
	args_debug=(
		"--prefix=$(pwd)/build"
		"--enable-gpl" "--enable-libx264" "--enable-libx265"
		# 协议与解复用器（只需要常用的）
		"--enable-protocol=tcp" "--enable-protocol=udp" "--enable-protocol=rtp" "--enable-demuxer=rtsp"
		# 禁用文档和工具（加快编译速度）
		"--disable-doc" "--disable-htmlpages" "--disable-manpages" "--disable-podpages" "--disable-txtpages"
		# 去掉额外的命令行工具编译（加快编译速度）
		"--disable-ffplay" "--disable-ffprobe"
		# 禁用非核心模块（减少干扰）
		"--disable-avdevice" "--disable-swresample" "--disable-postproc"
		# 禁用所有平台优化（防止汇编干扰）
		"--disable-asm" "--disable-mmx" "--disable-sse" "--disable-avx" "--disable-vfp" "--disable-neon" "--disable-inline-asm" "--disable-x86asm" "--disable-mipsdsp"
		# 禁用所有编译器优化（-O0）
		"--disable-optimizations"
		# 开启动态库的调试符号
		"--disable-stripping"
		# 调试核心配置（最高调试级别）
		"--enable-debug=3"
		"--ignore-tests=TESTS"
	)

	#args_debug=(
	#	# 在开始前，确保你已经安装了 libx264, libx265, 和 libaom (for AV1) 的开发库
	#	# 例如在 Ubuntu: sudo apt-get install libx264-dev libx265-dev libaom-dev
	#	# 在 macOS (brew): brew install x264 x265 aom
	#	"--prefix=$(pwd)/build"
	#	"--disable-everything"
	#	"--enable-gpl"
	#	"--enable-nonfree"
	#	"--enable-debug"
	#	"--disable-stripping"

	#	# 2. 启用你需要的编、解码器
	#	"--enable-libx264" "--enable-libx265" "--enable-libdav1d" "--enable-libaom"
	#	"--enable-encoder=aac"
	#	"--enable-decoder=h264"
	#	"--enable-decoder=hevc"
	#	"--enable-decoder=av1"
	#	"--enable-decoder=aac"

	#	# 3. 启用你需要的封装/解封装格式 (Muxer/Demuxer)
	#	"--enable-muxer=mp4"
	#	"--enable-demuxer=mov"
	#	"--enable-muxer=hevc"
	#	"--enable-muxer=h264"
	#	"--enable-muxer=ivf"

	#	# 4. 启用支持上述格式所需的解析器 (Parser)
	#	"--enable-parser=h264"
	#	"--enable-parser=hevc"
	#	"--enable-parser=av1"
	#	"--enable-parser=aac"

	#	# 5. 启用最基本的协议（如果需要处理本地文件）
	#	"--enable-protocol=file"

	#	# 6. 禁用文档和工具（加快编译速度）
	#	"--disable-doc" "--disable-htmlpages" "--disable-manpages" "--disable-podpages" "--disable-txtpages"
	#)

	#--enable-libxcb 使用xcb需要去掉--disable-avdevice
	#--enable-small \ #会强制添加-Os编译选项

	#编译较小的ffmpeg、最大化便于调试、开启正常优化
	args_release=(
		"--prefix=$(pwd)/build"
		"--enable-gpl" "--enable-libx264" "--enable-libx265"
		"--enable-protocol=tcp" "--enable-protocol=udp" "--enable-protocol=rtp" "--enable-demuxer=rtsp"
		"--disable-doc" "--disable-htmlpages" "--disable-manpages" "--disable-podpages" "--disable-txtpages"
		"--disable-ffplay" "--disable-ffprobe"
		"--disable-avdevice" "--disable-swresample" "--disable-postproc"
		"--disable-stripping" "--enable-debug=3" "--ignore-tests=TESTS"
	)
	#不要用-ggdb，-g3就是最高调试级别，-ggdb反而没有这么多调试信息
	#--disable-stripping 开启动态库的调试符号
	#--enable-libxcb 使用xcb需要去掉--disable-avdevice
	#--enable-small \ #会强制添加-Os编译选项

	export PKG_CONFIG_PATH=${work_dir}/${x265_version}/build/lib/pkgconfig:${work_dir}/${x264_version}/build/lib/pkgconfig
	#pkg-config --with-path=${work_dir}/${x264_version}/build/lib/pkgconfig/ --libs --cflags x264
	#pkg-config --with-path=${work_dir}/${x265_version}/build/lib/pkgconfig/ --libs --cflags x265

	if [ "$static" == "1" ]; then
		if [ $debug ]; then
			confg_static "${args_debug[@]}"
		else
			confg_static "${args_release[@]}"
		fi
	elif [ "$shared" == "1" ]; then
		if [ $debug ]; then
			confg_shared "${args_debug[@]}"
		else
			confg_shared "${args_release[@]}"
		fi
	fi

	${make} && make install
	popd
}

confg_static() {
	# 如果开启了 --enable-libx265 会一直报错：ERROR: x265 not found using pkg-config，已经解决： 报错原因：/usr/bin/ld: cannot find -lgcc_s: No such file or directory，
	# 解决：
	if [ $(uname) == "Linux" ]; then
		sed -i 's/Libs.private: -lstdc++ -lm -lgcc_s -lgcc -lgcc_s -lgcc -lrt -ldl/Libs.private: -lstdc++ -lm/' ${work_dir}/${x265_version}/build/lib/pkgconfig/x265.pc
	fi

	local -a args=("$@")
	if [ $debug ]; then
		args+=("--extra-cflags=-static -O0 -g3 -Wno-deprecated-declarations -w")
	else
		args+=("--extra-cflags=-static -g3 -Wno-deprecated-declarations")
	fi
	# -Wdeprecated-declarations 不打印函数过时的警告
	if [ "$(uname)" == "Darwin" ]; then
		#ERROR:No working C compiler found.
		echo "默认部分静态链接"
		args+=("--extra-ldflags=-rpath ${work_dir}/${x265_version}/build")
		#--extra-ldflags="-rpath ${work_dir}/${x265_version}/build" 对于x265需要重新指定rpath（MacOS for Arm），不然编译后会需要手动指定DYLD_LIBRARY_PATH
	elif [ "$(uname)" == "Linux" ]; then
		args+=("--extra-ldflags=-static")
		if [ $hwaccel ]; then
			args+=("${hwaccel}")
		fi
	fi
	args+=("--pkg-config-flags=--static")

	./configure "${args[@]}"
}

confg_shared() {
	#使用动态库：
	#1.删除 --extra-cflags="-static" --extra-ldflags="-static" \
	#2.添加 --enable-shared \
	local -a args=("$@")

	if [ $debug ]; then
		args+=("--extra-cflags=-O0 -g3 -Wno-deprecated-declarations -w")
	else
		args+=("--extra-cflags=-g3 -Wno-deprecated-declarations")
	fi
	args+=("--enable-shared")
	args+=("--disable-static")
	if [ "$(uname)" == "Darwin" ]; then
		echo "TODO"
		args+=("--extra-ldflags=-rpath ${work_dir}/${x265_version}/build")
		#--extra-ldflags="-rpath ${work_dir}/${x265_version}/build" 对于x265需要重新指定rpath（MacOS for Arm），不然编译后会需要手动指定DYLD_LIBRARY_PATH
	elif [ "$(uname)" == "Linux" ]; then
		if [ $hwaccel ]; then
			args+=("${hwaccel}")
		fi
		args+=("--extra-ldflags=-Wl,-rpath=build/lib:${work_dir}/${x265_version}/build")
	fi
	./configure "${args[@]}"
}

fetch_x264_lib() {
	local type="$1"
	pushd $work_dir

	if [ ! -d "$x264_version" ]; then
		if [ ! -f "$x264" ]; then wget https://code.videolan.org/videolan/x264/-/archive/master/x264-master.tar.bz2; fi
		tar -xjvf $x264
	fi

	cd $x264_version

	if [ $debug ]; then
		args=(
			"--prefix=$(pwd)/build"
			"--disable-asm"
			"--disable-opencl"
			"--disable-cli"
			"--enable-debug"
			"--extra-cflags=-g3 -O0 -w"
		)
	else
		args=(
			"--prefix=$(pwd)/build"
			"--disable-cli"
			"--extra-cflags=-g3"
		)
	fi

	#--disable-asm: 禁用汇编代码优化。
	#--disable-cli: 禁用 x264 命令行工具的构建。
	#--disable-opencl: 禁用 OpenCL 支持。
	#--disable-avs, --disable-lavf, --disable-swscale: 禁用其他库的依赖。
	#--disable-strip: 禁用从可执行文件和库中删除调试符号。
	#--extra-cflags="-g -O0": 添加编译器选项:
	#-g: 包含调试信息.
	#-O0: 禁用所有代码优化。

	if [ "$type" == "static" ]; then
		args+=("--enable-static")
		#--enable-static: 启用静态库的构建。
		if [ "$(uname)" == "Darwin" ]; then
			#ERROR:No working C compiler found.
			echo "默认部分静态链接"
		elif [ "$(uname)" == "Linux" ]; then
			args+=("--extra-ldflags=-static")
		fi
		#--extra-ldflags="-static": 添加链接器选项:
		#-static: 使用静态链接。
	elif [ "$type" == "shared" ]; then
		args+=("--enable-shared")
	else
		echo -e "\033[31mfetch_x264_lib failed\033[0m"
		exit
	fi
	${make} clean
	./configure "${args[@]}"
	${make} && make install
	popd
}

fetch_x265_lib() {
	local type="$1"
	pushd $work_dir

	if [ ! -d "$x265_version" ]; then
		if [ ! -f "$x265" ]; then
			wget https://bitbucket.org/multicoreware/x265_git/downloads/${x265} -O $x265
		fi
		tar -xvf $x265
	fi

	cd $x265_version/build

	if [ $debug ]; then
		args=(
			"-DCMAKE_CXX_FLAGS=-g3 -O0 -w"
			"-DCMAKE_C_FLAGS=-g3 -O0 -w"
			"-DCMAKE_INSTALL_PREFIX=${work_dir}/${x265_version}/build"
			# 启用调试符号，禁用优化
			"-DCMAKE_BUILD_TYPE=Debug"
			# 禁用汇编优化（简化代码路径）
			"-DENABLE_ASSEMBLY=OFF"
			# 保留命令行工具（方便测试）
			"-DENABLE_CLI=ON"
			# 禁用高比特深度（减少复杂度）
			"-DHIGH_BIT_DEPTH=OFF"
			# 禁用位置无关代码（简化链接）
			"-DENABLE_PIC=OFF"
			# 启用运行时检查（额外调试）
			"-DCHECKED_BUILD=ON"
			# TODO
			"-DSTATIC_LINK_CRT=OFF"
		)
	else
		args=(
			"-DCMAKE_CXX_FLAGS=-g3"
			"-DCMAKE_C_FLAGS=-g3"
			"-DCMAKE_INSTALL_PREFIX=${work_dir}/${x265_version}/build"
		)
	fi
	#NOTE: 如果是下载的源代码包文件如tar.gz，那么就不会有版本信息，因为cmake会通过git检测版本，当版本信息未知时，会跳过对pkg_config的生成
	#NOTE: 如果cmake警告Could NOT find NUMA，则：sudo apt install libnuma-dev
	#NOTE: 汇编器: The package name passed to `find_package_handle_standard_args` (nasm) -> sudo apt install nasm

	if [ "$type" == "static" ]; then
		args+=("-DENABLE_SHARED=OFF")
	elif [ "$type" == "shared" ]; then
		args+=("-DENABLE_SHARED=ON")
	else
		echo -e "\033[31mfetch_x265_lib failed\033[0m"
		exit
	fi
	${make} clean
	cmake -G "Unix Makefiles" "${args[@]}" ../source
	#NOTE: Cmake可以生成compile_commands_file
	make && make install
	popd
}

make_clean() {
	local lists=(
		${work_dir}/${x264_version}
		${work_dir}/${x265_version}/build
		${work_dir}/${ff_version}
	)

	for d in ${lists[@]}; do
		pushd $d
		make clean
		popd
	done
}

usage() {
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
	--build_x264                Separate compilation libx264
	--build_x265                Separate compilation libx265
	--build_ffmpeg              Separate compilation ffmpeg"
}

while getopts ":hdpvf:D:-:" opt; do
	case "${opt}" in
	h) usage && exit 0 ;;
	d) set -x ;;
	p) set -o posix ;;
	v)
		echo "$0 -- Version $ScriptVersion"
		exit
		;;
	f) file=${OPTARG} ;;
	D) directory=${OPTARG} ;;
	-) case "${OPTARG}" in
		help) usage && exit 0 ;;
		debug) set -x ;;
		posix) set -o posix ;;
		version)
			echo "$0 -- Version $ScriptVersion"
			exit
			;;
		file)
			file=${!OPTIND}
			OPTIND=$((OPTIND + 1))
			;;
		directory)
			directory=${!OPTIND}
			OPTIND=$((OPTIND + 1))
			;;
		static)
			static=1
			shared=0
			;;
		shared)
			shared=1
			static=0
			;;
		build_ffmpeg)
			build_ff
			exit
			;;
		build_x264)
			fetch_x264_lib shared
			exit
			;;
		build_x265)
			fetch_x265_lib shared
			exit
			;;
		clean)
			make_clean
			exit
			;;
		*) echo "Invalid option: --${OPTARG}" >&2 && exit 1 ;;
		esac ;;
	:) echo "Option -${OPTARG} requires an argument." >&2 && exit 1 ;;
	*) echo "Invalid option: -${OPTARG}" >&2 && exit 1 ;;
	esac
done
shift $((OPTIND - 1))

main "$@"

#动态编译时间：
#________________________________________________________
#Executed in   66.57 secs    fish           external
#   usr time  531.84 secs    0.00 micros  531.84 secs
#   sys time   65.06 secs  974.00 micros   65.06 secs

#静态编译时间：
#________________________________________________________
#Executed in   73.16 secs    fish           external
#   usr time  536.23 secs    0.00 micros  536.23 secs
#   sys time   73.83 secs  941.00 micros   73.82 secs
