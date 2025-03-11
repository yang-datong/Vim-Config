#!/bin/bash

hbbr=rustdesk-server-hbbr_1.1.14_amd64.deb
hbbs=rustdesk-server-hbbs_1.1.14_amd64.deb
server=rustdesk-server-linux-amd64.zip

#RustDesk 中继服务器
if [ ! -f $hbbr ]; then
	wget https://github.com/rustdesk/rustdesk-server/releases/download/1.1.14/rustdesk-server-hbbr_1.1.14_amd64.deb
fi

#RustDesk ID注册服务器
if [ ! -f $hbbs ]; then
	wget https://github.com/rustdesk/rustdesk-server/releases/download/1.1.14/rustdesk-server-hbbs_1.1.14_amd64.deb
fi

#if [ ! -f $server ]; then
#wget https://github.com/rustdesk/rustdesk-server/releases/download/1.1.14/rustdesk-server-linux-amd64.zip
#fi

sudo dpkg -i $hbbr
sudo dpkg -i $hbbs

#hbbr &
#hbbs &

echo "执行hbbr,hbbs出现错误：Error: Address in use (os error 98)，则查看端口占用情况：lsof -i:21116，如果无法处理，则改变端口号，比如hbbs -p 22226 , hbbr -p 22227"

echo "复制hbbr输出的key，然后在rustdesk客户端中网络配置，写入ID服务器：运行hbbr的机器的ip+端口，比如192.168.8.37:22226（连接机器与被连接机器都需要配置），然后写入key，即可"
