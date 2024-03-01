#!/bin/bash

if [ ! -x "$(command -v wine)" ];then
	echo "wine not installed ....."
	exit
fi

if [ ! -f "python-3.9.13-embed-amd64.zip" ];then
	wget https://www.python.org/ftp/python/3.9.13/python-3.9.13-embed-amd64.zip
fi


D="$HOME/.wine/drive_c/Program Files/Python3"

if [ ! -d "$D" ];then
	mkdir "$D"
	unzip python-3.9.13-embed-amd64.zip -d "$D"
fi

echo "执行命令：wine regedit , 然后在 HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment,PATH选项中最后添加 ;C:\Program Files\Python3"

echo "然后在 HKEY_CURRENT_USER\Software\Hex-Rays\IDA, 添加 Python3TargetDLL 为我们上面的python目录下的python3.dll绝对路径 C:\Program Files\Python3\python3.dll"


read -p "是否完成？[Y/n]"  ok

if [ "$ok" == "n" ];then
	echo -e "\033[31m 退出中。。。\033[0m"
	exit
fi

#开始解决Python库问题，即pip

if [ ! -f "get-pip.py" ];then
	wget https://bootstrap.pypa.io/get-pip.py
fi
wine python.exe ./get-pip.py

#设置python库的搜索路径
echo "./Lib/site-packages/" >> "$HOME/.wine/drive_c/Program Files/Python3/python39._pth"

#安装Microsoft Visual C++ redistributable及安装，最新版本的 Microsoft Visual C++
#sudo apt install winetricks && sudo winetricks --self-update && winetricks vcrun2017

#这里可能会发送错误，多跑几次

wine python.exe -m pip install yara keystone


#跑不下去了，一直报这个错误，解决了一上午都没解决，算了
#      error: Microsoft Visual C++ 14.0 or greater is required. Get it with "Microsoft C++ Build Tools": https://visualstudio.microsoft.com/visual-cpp-build-tools/
