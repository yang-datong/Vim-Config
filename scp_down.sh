#!/usr/bin/expect

set file  [lindex $argv 0]
set ip [lindex $argv 1]
set pswd "ppp\n"
set name "hnhuangjingyu"


spawn scp -r  $name@$ip:$file  ./
expect {
        "password:"
        {send $pswd}
	}
interact
