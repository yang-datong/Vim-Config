#!/bin/bash

set -e

url="https://"
target_dir=$HOME/.config/clash
clash_version="v1.19.3"
arch="$(uname -m)"

set_systemctl() {
	if [ $(uname) == "Linux" ]; then

		if [ -f /etc/systemd/system/clash.service ]; then
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

	else #Macos
		if [ -f $HOME/Library/LaunchAgents/com.example.clash.plist ]; then
			rm $HOME/Library/LaunchAgents/com.example.clash.plist
		fi

		if [ ! -d $HOME/Library/LaunchAgents ]; then
			mkdir $HOME/Library/LaunchAgents
		fi
		#这里写入一个文件后就会将服务添加到登录项的允许在后台中运行中
		echo "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NUWVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VOIiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4wLmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdD4KICAgIDxrZXk+TGFiZWw8L2tleT4KICAgIDxzdHJpbmc+Y29tLnJsLmNsYXNoPC9zdHJpbmc+CiAgICA8a2V5PlByb2dyYW1Bcmd1bWVudHM8L2tleT4KICAgIDxhcnJheT4KICAgICAgICA8c3RyaW5nPi9Vc2Vycy9oaS8uY29uZmlnL2NsYXNoL2NsYXNoPC9zdHJpbmc+CiAgICAgICAgPHN0cmluZz4tZDwvc3RyaW5nPgogICAgICAgIDxzdHJpbmc+L1VzZXJzL2hpLy5jb25maWcvY2xhc2g8L3N0cmluZz4KICAgIDwvYXJyYXk+CiAgICA8a2V5PlJ1bkF0TG9hZDwva2V5PgogICAgPHRydWUvPgogICAgPGtleT5LZWVwQWxpdmU8L2tleT4KICAgIDx0cnVlLz4KPC9kaWN0Pgo8L3BsaXN0Pgo=" | base64 -d >$HOME/Library/LaunchAgents/com.rl.clash.plist

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
		echo "配置完后，在config.yaml文件内，将使用的节点中skip-cert-verify字段修改为true"
	fi
}

download_clash() {
	local clash_file="mihomo-$(uname -o | awk '{print tolower($0)}')-$(uname -m)-${clash_version}.gz"
	local clash_bin=${clash_file%.*}
	if [ ! -f ${target_dir}/clash ]; then
		if [ ! -f ${clash_file} ] && [ ! -f ${clash_bin} ]; then
			wget https://github.com/MetaCubeX/mihomo/releases/download/${clash_version}/${clash_file} -O $clash_file
			#这一步会覆盖原有的压缩文件，即压缩后的文件会替换为压缩文件，所以这里删除了原压缩文件
			gunzip $clash_file
		fi
		if [ -f ${clash_bin} ]; then
			cp ${clash_bin} ${target_dir}/clash
			chmod +x ${target_dir}/clash
		fi
		if [ ! -f ${target_dir}/clash ]; then
			echo -e "\033[31mDownload clash failed\033[0m"
			exit 1
		fi
	fi

	local countrt_mmdb_version=20250212
	if [ ! -f ${target_dir}/Country.mmdb ]; then
		wget https://github.com/Dreamacro/maxmind-geoip/releases/download/${countrt_mmdb_version}/Country.mmdb -O Country.mmdb
		cp Country.mmdb ${target_dir}/
	fi

	if [ ! -f ${target_dir}/geosite.dat ]; then
		wget https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat -O geosite.dat
		cp geosite.dat ${target_dir}/
	fi

	if [ -f ${target_dir}/config.yaml ]; then
		echo "bWl4ZWQtcG9ydDogNzg5MApwb3J0OiA3ODkwCnNvY2tzLXBvcnQ6IDc4OTEKbW9kZTogcnVsZSAjIOaooeW8j++8mnJ1bGXvvIjop4TliJnvvInjgIFnbG9iYWzvvIjlhajlsYDvvInjgIFkaXJlY3TvvIjnm7Tov57vvIkKCmFsbG93LWxhbjogdHJ1ZQpiaW5kLWFkZHJlc3M6ICIqIgppcHY2OiB0cnVlCmxvZy1sZXZlbDogaW5mbwpleHRlcm5hbC1jb250cm9sbGVyOiAxMjcuMC4wLjE6OTA5MAo=" | base64 -d >config.yaml
		cp config.yaml ${target_dir}/
	fi

	echo "rm $clash_bin Country.mmdb geosite.dat config.yaml"
}

if [ ! -d ${target_dir} ]; then
	mkdir ${target_dir}
fi
download_clash
set_systemctl
