#!/bin/bash

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias huya="echo '15886670991, qweasdzxc123'"

alias cl='clear'
alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias cat='bat -p'
alias vim='nvim'
alias gdb='lldb'
alias pping="httping -x 127.0.0.1:7890"
alias diff='colordiff -w'
alias ldd='otool -L'
alias ida='/Applications/IDA\ Professional\ 9.0.app/Contents/MacOS/ida'

alias pip='pip3.10'
alias pip3='pip3.10'
alias python='python3.10'
alias python3='python3.10'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c17 -Wall'
alias clang++='clang++ -std=c++14 -Wall'
alias gcc='gcc -std=c17 -Wall'
alias g++='g++ -std=c++14 -Wall'
alias set-proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
alias dis-proxy='export https_proxy= http_proxy= all_proxy='

# ffmpeg
alias ffmpeg-q="ffmpeg -loglevel quiet"
alias ffplay-q="ffplay -loglevel quiet"
alias ffprobe-q="ffprobe -loglevel quiet"
