#Ubuntu 20.04

PS1='\033[1;37m\$ \033[0m'
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

shopt -s checkwinsize #在每个命令之后检查窗口大小，并在必要时更新LINES和COLUMNS的值

export PATH=$PATH:$HOME/.local/bin/
export PATH=$PATH:$HOME/Android/Sdk/ndk/21.4.7075529
export PATH=$PATH:$HOME/MySoftWare/Inkscape
export PATH=$PATH:$HOME/MySoftWare/jadx/bin

export SH_FOOT=$HOME/sh_foot
export CLOUD=/run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
export JAVA_HOME=$HOME/MySoftWare/android-studio/jbr
export ANDROID_NDK_ROOT=$HOME/Android/Sdk/ndk/25.1.8937393

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias huya="echo '15886670991, qweasdzxc123'"

alias ls='ls --color'
alias cl='clear'
alias rm-rf='rm -rf'
alias du='du -sh'
alias vim='nvim'
alias axel='axel -n 16'
alias pping="httping -x 127.0.0.1:7890"

alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias apt='sudo apt'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c17 -Wall'
alias clang++='clang++ -std=c++14 -Wall'
alias gcc='gcc -std=c17 -Wall'
alias g++='g++ -std=c++14 -Wall'
alias set-proxy='source /usr/local/bin/set-proxy'
