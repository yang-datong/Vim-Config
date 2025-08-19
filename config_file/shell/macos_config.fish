if status is-interactive

set fish_greeting #去除提示

#MacOS
#set -x PATH $PATH $HOME/Library/Android/sdk/ndk/21.1.6352462
set -x PATH /opt/homebrew/bin $PATH #Apple silicon M1芯片安装的brew会在/opt目录下（注意顺序，这里提高了homebrew的优先级，是因为在某些情况下会有重复的软件，但版本不同）
set -x PATH $PATH /Applications/Inkscape.app/Contents/MacOS
set -x PATH $PATH $HOME/Library/Python/3.10/bin
set -x PATH $PATH $HOME/.local/bin/

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD $HOME/Library/Mobile\ Documents/com~apple~CloudDocs
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
set -x ANDROID_NDK_ROOT $HOME/Library/Android/Sdk/ndk/25.1.8937393

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

# TODO?
set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
