#!/bin/bash
url_list=""
sum=1
while read line;do
	echo -e "[InternetShortcut]\nURL=$line" >> ${sum}.url
	((sum++))
done < $url_list
