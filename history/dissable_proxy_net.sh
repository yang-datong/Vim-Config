#!/bin/bash


echo -e "\033[31minput dele ip proxy :"
read ip

echo -e "\033[32mprepare delete following ip proxy :"
net=$(netstat -nr | grep 1.0.0.1 | head -1 | awk '{print $2}')

for i in $(netstat -nr | grep $net | grep $ip | awk '{print $1 }')
do
	sudo route delete $i $net
done


