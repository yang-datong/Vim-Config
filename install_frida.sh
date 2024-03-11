#!/bin/bash
set -e

version=16.0.8
pip3 install frida==${version} frida-tools #安装Frida CLI 工具

wget https://github.com/frida/frida/releases/download/${version}/frida-server-${version}-android-arm64.xz #拉取远程手机端服务

xz -d frida-server-${version}-android-arm64.xz

adb push ./frida-server-${version}-android-arm64 /data/local/tmp/frida-server

adb shell "su -c 'chmod a+x /data/local/tmp/frida-server'" #添加执行权限
