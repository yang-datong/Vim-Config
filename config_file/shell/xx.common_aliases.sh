#!/bin/bash

alias cl='clear'
alias rm='trash'
alias du='du -sh'
alias vim='nvim'
alias pping="httping -x 127.0.0.1:7890"
alias diff='colordiff -w'
alias mkdir='mkdir -p'

alias pip='pip3.10'
alias pip3='pip3.10'
alias python='python3.10'
alias python3='python3.10'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w'
alias clang='clang -std=c99 -Wall'
alias clang++='clang++ -std=c++14 -Wall'
alias gcc='gcc -std=c17 -Wall'
alias g++='g++ -std=c++14 -Wall'
alias set-proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
alias dis-proxy='export https_proxy= http_proxy= all_proxy='

# ffmpeg
alias ffmpeg="ffmpeg -hide_banner"
alias ffmpeg-q="ffmpeg -loglevel quiet"
alias ffplay-q="ffplay -loglevel quiet"
alias ffprobe-q="ffprobe -loglevel quiet"

# perf
alias perf-top="perf top"
alias perf-stat="perf stat"
alias perf-record="perf record"
alias perf-report="perf report"
alias perf-kernel="perf record -e cycles:u -a --call-graph dwarf"
