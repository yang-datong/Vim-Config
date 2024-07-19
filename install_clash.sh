#!/bin/bash

set -e

url="https://suc.fallin.pw/sub?target=clash&url=https%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D2%7Chttps%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D1%7Chttps%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D3%7Chttps%3A%2F%2Fviper9096.fallin.pw%2Flink%2FzdPXXHkpKMQ9so5r%3Fsub%3D4&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_Online_NoAuto.ini&filename=Fallin%E4%B8%96%E7%95%8C&emoji=true&list=false&tfo=false&scv=false&fdn=false&sort=false&new_name=true"

download_config(){
	wget "${url}" -O config.yaml
	if [ $(uname) == "Linux" ];then
		sudo mv config.yaml $HOME/.config/clash/
	else
		mv config.yaml $HOME/.config/clash/
	fi
}

set_systemctl(){
	if [ $(uname) == "Linux" ];then

		if [ -f /etc/systemd/system/clash.service ];then
			sudo rm /etc/systemd/system/clash.service
		fi
		echo "W1VuaXRdCkRlc2NyaXB0aW9uPUNsYXNoIGRhZW1vbgpBZnRlcj1uZXR3b3JrLnRhcmdldAoKW1NlcnZpY2VdClR5cGU9c2ltcGxlClJlc3RhcnQ9YWx3YXlzCkV4ZWNTdGFydD0vaG9tZS9oaS8uY29uZmlnL2NsYXNoL2NsYXNoIC1kIC9ob21lL2hpLy5jb25maWcvY2xhc2gKCltJbnN0YWxsXQpXYW50ZWRCeT1tdWx0aS11c2VyLnRhcmdldAoK" | base64 -d | sudo tee -a /etc/systemd/system/clash.service
		#开机自启
		sudo systemctl enable clash
		#开启clash
		sudo systemctl start clash
		#查看clash日志
		sudo systemctl status clash
		sudo journalctl -xe

	else
		if [ -f $HOME/Library/LaunchAgents/com.example.clash.plist ];then
			rm $HOME/Library/LaunchAgents/com.example.clash.plist
		fi

		#这里写入一个文件后就会将服务添加到登录项的允许在后台中运行中
		echo "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdD4KICAgIDxrZXk+TGFiZWw8L2tleT4KICAgIDxzdHJpbmc+Y29tLnJsLmNsYXNoPC9zdHJpbmc+CiAgICA8a2V5PlByb2dyYW1Bcmd1bWVudHM8L2tleT4KICAgIDxhcnJheT4KICAgICAgICA8c3RyaW5nPi9Vc2Vycy9oaS8uY29uZmlnL2NsYXNoL2NsYXNoPC9zdHJpbmc+CiAgICAgICAgPHN0cmluZz4tZDwvc3RyaW5nPgogICAgICAgIDxzdHJpbmc+L1VzZXJzL2hpLy5jb25maWcvY2xhc2g8L3N0cmluZz4KICAgIDwvYXJyYXk+CiAgICA8a2V5PlJ1bkF0TG9hZDwva2V5PgogICAgPHRydWUvPgogICAgPGtleT5LZWVwQWxpdmU8L2tleT4KICAgIDx0cnVlLz4KPC9kaWN0Pgo8L3BsaXN0Pgo=" | base64 -d > $HOME/Library/LaunchAgents/com.rl.clash.plist

		# 加载服务并启动（重新运行会报错）
		launchctl load -w $HOME/Library/LaunchAgents/com.rl.clash.plist

		#停止服务
		launchctl bootout gui/$(id -u) $HOME/Library/LaunchAgents/com.rl.clash.plist
		#重启服务
		launchctl bootstrap gui/$(id -u) $HOME/Library/LaunchAgents/com.rl.clash.plist

		# 查看服务状态（第一次安装后需要重启）
		launchctl list | grep com.rl.clash #如果第二项值为0则表示服务成功运行

		# 查看服务日志
		log show --predicate 'process == "clash"' --info --last 1h
	fi
}

ubuntu(){
	if [ ! -d $HOME/.config/clash ];then
		sudo mkdir $HOME/.config/clash
	fi
	if [ ! -f clash-linux-amd64-v1.18.0.gz ];then
		wget "https://drive.rocklinuxmirror.eu.org/index.php/s/5MndEnkeqzpiiS2/download?path=%2F&files=clash-linux-amd64-v1.18.0.gz" -O clash-linux-amd64-v1.18.0.gz
		gunzip clash-linux-amd64-v1.18.0.gz
	fi
	if [ -f clash-linux-amd64-v1.18.0 ];then
		sudo mv clash-linux-amd64-v1.18.0 $HOME/.config/clash/clash
		chmod +x $HOME/.config/clash/clash
	fi
	if [ ! -f $HOME/.config/clash/clash ];then
		echo -e "\033[31mDownload clash failed\033[0m";exit
	fi
	if [ ! -f $HOME/.config/clash/clash/Country.mmdb ];then
		wget https://github.com/Dreamacro/maxmind-geoip/releases/download/20240512/Country.mmdb -O Country.mmdb
		sudo mv Country.mmdb $HOME/.config/clash/
	fi
	download_config
	set_systemctl
}


mac(){
	if [ ! -d $HOME/.config/clash ];then
		mkdir $HOME/.config/clash
	fi
	if [ ! -f Clash.Meta-darwin-amd64-v1.14.0.gz ] && [ ! -f $HOME/.config/clash/clash ];then
		wget "https://github.com/MetaCubeX/mihomo/releases/download/v1.14.0/Clash.Meta-darwin-amd64-v1.14.0.gz" -O Clash.Meta-darwin-amd64-v1.14.0.gz
		gunzip Clash.Meta-darwin-amd64-v1.14.0.gz
	fi
	if [ -f Clash.Meta-darwin-amd64-v1.14.0 ];then
		mv Clash.Meta-darwin-amd64-v1.14.0 $HOME/.config/clash/clash
		chmod +x $HOME/.config/clash/clash
	fi
	if [ ! -f $HOME/.config/clash/clash ];then
		echo -e "\033[31mDownload clash failed\033[0m";exit
	fi
	if [ ! -f $HOME/.config/clash/Country.mmdb ];then
		wget https://github.com/Dreamacro/maxmind-geoip/releases/download/20240512/Country.mmdb -O Country.mmdb
		sudo mv Country.mmdb $HOME/.config/clash/
	fi
	download_config
	set_systemctl
	echo "配置完后，在config.yaml文件内，将使用的节点中skip-cert-verify字段修改为true"
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";mac;;
		"Linux") cc="sudo apt -y";ubuntu;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os
