#!/bin/bash

set -e

url="https://suc.fallin.pw/sub?target=clash&url=https%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D2%7Chttps%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D1%7Chttps%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D3%7Chttps%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D4&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_Online_NoAuto.ini&filename=Fallin%E4%B8%96%E7%95%8C&emoji=true&list=false&tfo=false&scv=false&fdn=false&sort=false&new_name=true"

download_config(){
	wget "${url}" -O config.yaml
	sudo mv config.yaml /opt/clash/
}

set_systemctl(){
	if [ -f /etc/systemd/system/clash.service ];then
		sudo rm /etc/systemd/system/clash.service
	fi
	echo "W1VuaXRdCkRlc2NyaXB0aW9uPUNsYXNoIGRhZW1vbgpBZnRlcj1uZXR3b3JrLnRhcmdldAoKW1NlcnZpY2VdClR5cGU9c2ltcGxlClJlc3RhcnQ9YWx3YXlzCkV4ZWNTdGFydD0vb3B0L2NsYXNoL2NsYXNoIC1kIC9vcHQvY2xhc2gKCltJbnN0YWxsXQpXYW50ZWRCeT1tdWx0aS11c2VyLnRhcmdldAoK" | base64 -d | sudo tee -a /etc/systemd/system/clash.service
	#开机自启
	sudo systemctl enable clash
	#开启clash
	sudo systemctl start clash
	#查看clash日志
	sudo systemctl status clash
	sudo journalctl -xe
}

ubuntu(){
	if [ ! -d /opt/clash ];then
		sudo mkdir /opt/clash
	fi
	if [ ! -f clash-linux-amd64-v1.18.0.gz ];then
		wget "https://drive.rocklinuxmirror.eu.org/index.php/s/5MndEnkeqzpiiS2/download?path=%2F&files=clash-linux-amd64-v1.18.0.gz" -O clash-linux-amd64-v1.18.0.gz
		gunzip clash-linux-amd64-v1.18.0.gz
	fi
	if [ -f clash-linux-amd64-v1.18.0 ];then
		sudo mv clash-linux-amd64-v1.18.0 /opt/clash/clash
		chmod +x /opt/clash/clash
	fi
	if [ ! -f /opt/clash/clash ];then
		echo -e "\033[31mDownload clash failed\033[0m";exit
	fi
	if [ ! -f /opt/clash/clash/Country.mmdb ];then
		wget https://github.com/Dreamacro/maxmind-geoip/releases/download/20240512/Country.mmdb -O Country.mmdb
		sudo mv Country.mmdb /opt/clash/
	fi
	download_config
	set_systemctl
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";;
		"Linux") cc="sudo apt -y";ubuntu;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os
