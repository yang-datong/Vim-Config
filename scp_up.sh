#!/usr/bin/expect

set file  [lindex $argv 0]
set ip [lindex $argv 1]
set type [lindex $argv 2]

set name "hnhuangjingyu"
set pswd "ppp\n"

spawn scp -r $file $name@$ip:./
expect {
        "password:"
        {send $pswd}
	}
interact
