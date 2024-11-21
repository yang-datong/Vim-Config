#!/bin/bash
set -e

target_path="/usr/local/bin"

self=$(basename $0)

main(){
	# Check file #
	for file in $(ls $SH_FOOT/tools | grep -v $self);do
		local local_file="$SH_FOOT/tools/$file"
		add_exec_permission "$local_file"
		remove_shell_script_suffix "$local_file"
	done

	#  这里去掉后缀后再重新遍历一次 # 
	for file in $(ls $SH_FOOT/tools | grep -v $self);do
		local local_file="$SH_FOOT/tools/$file"
		if [ "$local_file" == "systemctl" ] && [ "$(uname)" == "Linux" ];then
			continue
		fi
		replace_symbols_link "${target_path}/${file}" "$SH_FOOT/tools/$file"
	done
}

add_exec_permission(){
	local file="$1"
	if [ ! -x "$file" ];then
		chmod +x "$file"
		echo -e "\033[32m$file add exec permission -> $file\033[0m"
	fi
}

remove_shell_script_suffix(){
	local file="$1"
	file_type=${file##*.}
	if [ $file_type == "sh" ];then
		file_name=${file%.*}
		mv $file $file_name
		echo -e "\033[32m$file update to -> $file_name\033[0m"
	fi
}

replace_symbols_link(){
	local file="$1"
	local really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31m Don't find the $really_file\033[0m";exit
	fi
	#remove_shell_script_suffix "$really_file"
	if [[ -h "$file" ]] || [[ -f "$file" ]];then
		local date=$(date +"%Y%m%d%H%M%S")
		sudo mv $file "/tmp/$(basename $file)_$date"
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		echo -e "\033[33m Add $file done~\033[0m"
	fi
		sudo ln -s $really_file $file
}

if [ ! $SH_FOOT ];then
	echo -e "\033[31m未定义\$SH_FOOT\033[0m";exit
fi

main
