#!/bin/bash
set -e

target_path="/usr/local/bin"

self=$(basename $0)

main(){
	for file in `ls $SH_FOOT/tools | grep -v $self`;do
		replace_symbols_link "${target_path}/${file}" "$SH_FOOT/tools/$file"
	done
}

#remove_shell_script_suffix(){
#	local file="$1"
#	file_type=${file##*.}
#	if [ $file_type == "sh" ];then
#		file_name=${file%.*}
#		mv $file $file_name
#	fi
#}

replace_symbols_link(){
	file="$1"
	really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31m Don't find the $really_file\033[0m"
		exit
	fi
	#remove_shell_script_suffix "$really_file"
	if [[ -h "$file" || -f "$file" ]];then
		local date=$(date +"%Y%m%d%H%M%S")
		sudo mv $file "/tmp/$(basename $file)_$date"
		sudo ln -s $really_file $file
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		#echo -e "\033[31m Not know file type -> $file \033[0m"
		sudo ln -s $really_file $file
		echo -e "\033[33m Add $file done~\033[0m"
	fi
}

if [ ! $SH_FOOT ];then
	echo -e "\033[31m未定义\$SH_FOOT\033[0m";exit
fi

main
