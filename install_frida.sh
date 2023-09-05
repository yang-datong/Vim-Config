#!/bin/bash
set -e

pip3 install frida==15.2.2 frida-tools #安装Frida CLI 工具

wget https://github.com/frida/frida/releases/download/15.2.2/frida-server-15.2.2-android-arm64.xz #拉取远程手机端服务

xz -d frida-server-15.2.2-android-arm64.xz

adb push ./frida-server-15.2.2-android-arm64 /data/local/tmp/frida-server

adb shell "su -c 'chmod a+x /data/local/tmp/frida-server'" #添加执行权限
