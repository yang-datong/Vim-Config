#!/bin/bash

target_path="/usr/local/bin"

self=$(basename $0)

main(){
	for file in `ls | grep -v $self`;do
		replace_symbols_link "${target_path}/${file}" "$(pwd)/$file"
	done
}

installs(){
	for file in `ls | grep -v $self`;do
		cp -v $file ${target_path}/${file%.*}
		chmod +x ${target_path}/${file%.*}
	done
}

replace_symbols_link(){
	file="$1"
	really_file="$2"
	if [ ! -f "$really_file" ];then
		echo -e "\033[31mDon't find the $really_file\033[0m"
		exit
	fi
	if [ ! -h "$file" ];then
		if [ -f "$file" ];then
			local date=$(date +"%Y%m%d%H%M%S")
			mv $file "/tmp/$(basename $file)_$date"
		fi
		echo "ln -s $really_file $file"
		ln -s $really_file $file
	fi
}

main
