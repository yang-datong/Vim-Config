#!/bin/bash

config_file="$HOME/.config/pip/pip.conf"

if [ ! -f ${config_file} ]; then
  mkdir -p ${config_file}
fi

cat <<EOF >${config_file}
[global]
index-url = https://pypi.tuna.tsinghua.edu.cn/simple
break-system-packages = true
user = true
EOF
