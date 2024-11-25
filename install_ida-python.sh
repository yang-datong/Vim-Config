#!/bin/bash

#https://www.debugwar.com/article/activate-IDAPython-with-wine-IDA-under-linux

ubuntu() {
	if [ ! -x "$(command -v wine)" ]; then
		echo "wine not installed ....."
		exit
	fi

	if [ ! -f "python-3.10.2-embed-amd64.zip" ]; then
		wget https://www.python.org/ftp/python/3.10.2/python-3.10.2-embed-amd64.zip
	fi

	D="$HOME/.wine/drive_c/Program Files/Python3"

	if [ ! -d "$D" ]; then
		mkdir "$D"
		unzip python-3.10.2-embed-amd64.zip -d "$D"
	fi

	echo "执行命令：wine regedit , 然后在 HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment,PATH选项中最后添加 ;C:\Program Files\Python3;C:\Program Files\Python3\Scripts"

	echo "然后在 HKEY_CURRENT_USER\Software\Hex-Rays\IDA, 添加 Python3TargetDLL 为我们上面的python目录下的python3.dll绝对路径 C:\Program Files\Python3\python3.dll"

	read -p "是否完成？[Y/n]" ok

	if [ "$ok" == "n" ]; then
		echo -e "\033[31m 退出中。。。\033[0m"
		exit
	fi

	#开始解决Python库问题，即pip
	if [ ! -f "get-pip.py" ]; then
		wget https://bootstrap.pypa.io/get-pip.py
	fi
	wine python.exe ./get-pip.py

	#设置python库的搜索路径
	echo "./Lib/site-packages/" >>"$HOME/.wine/drive_c/Program Files/Python3/python310._pth"

	#安装Microsoft Visual C++ redistributable及安装，最新版本的 Microsoft Visual C++
	#sudo apt install winetricks && sudo winetricks --self-update && winetricks vcrun2017
	#这里可能会发送错误，多跑几次（出问题了再运行）

	wine python.exe -m pip install keystone-engine six yara

	cp -r ~/.wine/drive_c/Program\ Files/Python3/Lib/site-packages/Program\ Files/Python3/DLLs ~/.wine/drive_c/Program\ Files/Python3/

	#下面的命令主要是针对（出问题了再运行）:使用Apply patches to保存修改时提示patching canceled..
	#https://blog.csdn.net/FigBB/article/details/134856961
	#cp $HOME/.wine/drive_c/Program\ Files/Python3/Lib/site-packages/PyQt5/sip.cp310-win_amd64.pyd $HOME/IDA_Pro_7.7/python/3/PyQt5/sip.pyd
	if [ -f ./get-pip.py ];then
		rm ./get-pip.py
	fi
}

#Check OS System
check_os() {
	case "$(uname)" in
	"Darwin") echo "未适配，不建议Mac OS用wine" ;;
	"Linux") ubuntu ;;
	*)
		echo "Windows has not been tested for the time being"
		exit 1
		;;
	esac
}

check_os
