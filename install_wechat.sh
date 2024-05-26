#!/bin/bash

if [ ! -f weixin_2.1.1_amd64.deb ];then
	wget "http://archive.ubuntukylin.com/software/pool/partner/weixin_2.1.1_amd64.deb"
fi

if [ ! -f wechat-beta_1.0.0.145_amd64.deb ];then
	wget "https://github.com/lovechoudoufu/wechat_for_linux/releases/download/wechat-beta/wechat-beta_1.0.0.145_amd64.deb"
fi


dpkg -l | grep wechat || sudo dpkg -i wechat-beta_1.0.0.145_amd64.deb
if [ ! -d out ];then
	dpkg -X weixin_2.1.1_amd64.deb out
fi
if [ ! -f /usr/lib/libactivation.so ];then
	sudo cp out/usr/lib/libactivation.so /usr/lib/libactivation.so
fi
if [ ! -f /etc/.kyact ];then
	sudo cp out/etc/.kyact /etc/.kyact
fi
if [ ! -f /etc/LICENSE ];then
	sudo cp out/etc/LICENSE /etc/LICENSE
fi

if [ ! -f /etc/lsb-release-ukui ];then
	echo "RElTVFJJQl9JRD1LeWxpbgpESVNUUklCX1JFTEVBU0U9VjEwCkRJU1RSSUJfQ09ERU5BTUU9a3lsaW4KRElTVFJJQl9ERVNDUklQVElPTj0iS3lsaW4gVjEwIFNQMSIKRElTVFJJQl9LWUxJTl9SRUxFQVNFPVYxMApESVNUUklCX1ZFUlNJT05fVFlQRT1lbnRlcnByaXNlCkRJU1RSSUJfVkVSU0lPTl9NT0RFPW5vcm1hbAo=" | base64 -d > lsb-release-ukui
	sudo mv lsb-release-ukui /etc/lsb-release-ukui
fi

if [ ! -f /opt/wechat-beta/lunch_wechat.sh ];then
	echo "bwrap --dev-bind / / --bind /etc/lsb-release-ukui /etc/lsb-release /usr/bin/wechat \$@" > lunch_wechat.sh
	sudo chmod 777 lunch_wechat.sh && sudo mv lunch_wechat.sh /opt/wechat-beta/lunch_wechat.sh
fi

sudo sed -i 's#/usr/bin/wechat %U#"/opt/wechat-beta/lunch_wechat.sh" %f#' /usr/share/applications/wechat.desktop
