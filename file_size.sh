#!/bin/bash
kb=$1

if [ -z "$kb" ];then
	kb=96
fi

echo -n "Bit  -> "
echo "scale=5;${kb}*1024*8" | bc

echo -n "Byts -> "
echo "scale=5;${kb}*1024" | bc

echo -n "KB   -> "
echo "scale=5;${kb}" | bc

echo -n "MB   -> "
echo "scale=5;${kb}/1024" | bc

echo -n "GB   -> "
echo "scale=5;${kb}/1024/1024" | bc

echo -n "TB   -> "
echo "scale=5;${kb}/1024/1024/1024" | bc
