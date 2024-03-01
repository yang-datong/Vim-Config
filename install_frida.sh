#!/bin/bash
set -e

pip3 install frida==16.0.8 frida-tools #安装Frida CLI 工具

wget https://github.com/frida/frida/releases/download/16.0.8/frida-server-16.0.8-android-arm64.xz #拉取远程手机端服务

xz -d frida-server-16.0.8-android-arm64.xz

adb push ./frida-server-16.0.8-android-arm64 /data/local/tmp/frida-server

adb shell "su -c 'chmod a+x /data/local/tmp/frida-server'" #添加执行权限
