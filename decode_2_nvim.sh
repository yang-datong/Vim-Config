#!/bin/bash

set -e

main(){
    if [ ! $1 ];then
        echo -e "\033[31m需要指定目录或文件名字\033[0m"
        exit
    fi
    if [ -f $1 ];then
        user_file "$1"
    elif [ -d $1 ];then
        use_directory "$1"
    else
        echo -e "\033[31m No exec\033[0m"
        exit
    fi
}


# 递归遍历目录函数
traverse_directory() {
    local directory="$1"

    # 遍历目录下的所有文件和子目录
    for file in "$directory"/*; do
        if [[ -f "$file" ]]; then
            echo "$file"
            if [ ${file##*.} == "zip" ];then
                echo -e "\033[31m跳过一个zip文件,采用cp方式\033[0m"
                cp -r $file $decode_directory/$file
            else    
                cat "$file" > "$decode_directory/$file"
            fi
        elif [[ -d "$file" ]]; then
            # 递归调用函数，遍历子目录
            if [ ! -d $decode_directory/$file ];then
                mkdir $decode_directory/$file
            fi
            traverse_directory "$file"
        fi
    done


}

use_directory(){
    local directory="$1"
    if [[ $directory == *"/"* ]];then
        echo -e "\033[31m No "/"\033[0m"
        exit
    fi
    local decode_directory="decode_$(basename $directory)"
    if [ ! -d $decode_directory ];then
        mkdir -p $decode_directory/$directory
    else
        #if [ ! -d $decode_directory/$directory ];then
        #    mkdir $decode_directory/$directory
        #else
            read -p "已经完成操作，要重新来吗？[y/N]" OK
            if [ "$OK" == "y" ];then
                local date=$(date +"%Y%m%d%H%M%S")
                mv $decode_directory /tmp/$date
                mkdir -p $decode_directory/$directory
            else
                exit
            fi
        #fi
    fi
    traverse_directory "$1"
    mv $decode_directory/$directory/* $decode_directory/
    rmdir $decode_directory/$directory
}

user_file(){
    local file="$1"
    local date=$(date +"%Y%m%d%H%M%S")
    cat $file > $date
    rm $file
    mv $date $file
}

main "$@"
