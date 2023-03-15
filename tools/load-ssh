#!/usr/bin/expect
set timeout 30

set ip  [lindex $argv 0]
set name "hnhuangjingyu"
set pswd "ppp\n"

spawn ssh $name@$ip
expect {
        "(yes/no)?"
        {send "yes\n";exp_continue}
        "password:"
        {send $pswd}
}
interact
