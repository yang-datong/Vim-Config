#!/bin/bash

#https://github.com/tickstep/aliyunpan

#Check OS System
check_os() {
	case "$(uname)" in
	"Darwin") OSX ;;
	"Linux") LNIUX ;;
	*)
		echo "Windows has not been tested for the time being"
		exit 1
		;;
	esac
}

unset DIR

LNIUX() {
	DIR=aliyunpan-v0.2.7-linux-386
}

OSX() {
	DIR=aliyunpan-v0.2.7-darwin-macos-amd64
}

check_os

wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.7/${DIR}.zip -O $TMPDIR/tmp.zip

unzip $TMPDIR/tmp.zip -d $HOME/

cd $HOME/$DIR

cat <<EOF
这个下载工具是阿里云盘的shell操作三方工具。优点：
- 阿里云盘下载超过100M的文件需要下载客户端，这个可以突破限制
- 这个工具的下载速度可达 10-20 M每秒

使用：
1. 先登陆网页版阿里云盘，获取refresh_token：https://www.aliyundrive.com/drive/file/backup
2. 地址栏输入：javascript:JSON.parse(localStorage.getItem("token")).refresh_token
2. (或者）控制台执行：JSON.parse(localStorage.getItem("token")).refresh_token
3. 项目shell执行

$ ./aliyunpan login -RefreshToken=8072a0cbb11848598aca4d879aa86000

# 下载操作：
$ ./aliyunpan
aliyunpan:/ tickstep$ download IMG_0106.JPG
# 上传操作：
aliyunpan:/ tickstep$ upload /Users/tickstep/Downloads/apt.zip /tmp
EOF
