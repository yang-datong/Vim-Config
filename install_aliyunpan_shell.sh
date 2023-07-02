#!/bin/bash


#这个下载工具是阿里云盘的shell操作三方工具。优点：
#1. 阿里云盘下载超过100M的文件需要下载客户端，这个可以突破限制
#2. 这个工具的下载速度可达 10-20 M每秒

#使用
#获取refresh_token : 
#1. 先登陆网页版阿里云盘：
#2. 控制台执行：JSON.parse(localStorage.getItem("token")).refresh_token
#3. 项目shell执行

#$ ./aliyunpan
#aliyunpan > login -RefreshToken=${refresh_token}
#aliyunpan:/ tickstep$ download IMG_0106.JPG
#aliyunpan:/ tickstep$ upload /Users/tickstep/Downloads/apt.zip /tmp

#Check OS System
check_os(){
	case "$(uname)" in
	"Darwin") OSX;;
	"Linux") LNIUX;;
	*)echo "Windows has not been tested for the time being";exit 1
	esac
}


LNIUX(){
	wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.7/aliyunpan-v0.2.7-linux-386.zip
	unzip aliyunpan-v0.2.7-linux-386.zip
}

OSX(){
	wget https://github.com/tickstep/aliyunpan/releases/download/v0.2.6/aliyunpan-v0.2.6-darwin-macos-amd64.zip
	unzip aliyunpan-v0.2.6-darwin-macos-amd64.zip

}

check_os
