if status is-interactive

#MacOS
set -x PATH $PATH /usr/local/Cellar
set -x PATH $PATH $HOME/Library/Python/3.9/bin
set -x PATH $PATH /usr/local/opt/binutils/bin
set -x PATH $PATH /usr/local/texlive/2022/bin/universal-darwin/
set -x PATH $PATH $HOME/Library/Android/sdk/ndk/21.1.6352462
set -x PATH $PATH /Applications/Inkscape.app/Contents/MacOS/
set -x PATH $PATH $HOME/.docker/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD $HOME/Library/Mobile\ Documents/com~apple~CloudDocs
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
set -x ANDROID_NDK_ROOT $HOME/Library/Android/Sdk/ndk/25.1.8937393

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias huya="echo '15886670991, qweasdzxc123'"
alias ip='curl -s -m 5 https://ipleak.net/json/'

alias cl='clear'
alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias cat='bat -p'
alias vim='nvim'
alias gdb='lldb'
alias pping="httping -x 127.0.0.1:7890"
alias pip='pip3.10'
alias pip3='pip3.10'
alias python='python3.10'
alias python3='python3.10'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++11 -Wall'
alias gcc='gcc -std=c11 -Wall'
alias g++='g++ -std=c++11 -Wall'
alias set-proxy='source /usr/local/bin/set-proxy'

eval "$(/opt/homebrew/bin/brew shellenv)" #可选高版本的MacOS安装的brew会在/opt目录下
set fish_greeting #去除提示
if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
