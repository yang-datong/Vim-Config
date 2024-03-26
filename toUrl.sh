#!/bin/bash
#临时写的一个快速写url文件的脚本
cat $0;exit;
url_list=""
sum=1
while read line;do
	echo -e "[InternetShortcut]\nURL=$line" >> ${sum}.url
	((sum++))
done < $url_list
