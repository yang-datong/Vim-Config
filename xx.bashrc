#PS1="\[\033[0;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\u@\h'; else echo '\[\033[0;32m\]\u@\h'; fi)\[\033[0;34m\] \w \$\[\033[00m\] "
#PS1='\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] '
PS1='\e[97m\$\e[96m '
#export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
export PATH=$PATH:/usr/local/Cellar
export PATH=$PATH:$HOME/Library/Python/3.9/bin
export PATH=$PATH:/usr/local/opt/binutils/bin
export PATH=$PATH:/usr/local/texlive/2022/bin/universal-darwin/
export PATH=$PATH:$HOME/Library/Android/sdk/ndk/21.1.6352462
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

shopt -s checkwinsize
#在每个命令之后检查窗口大小，并在必要时
#更新LINES和COLUMNS的值

export CLOUD=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias cl='clear'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'
alias chown='sudo chown'
alias chgrp='sudo chgrp'
alias apt='sudo apt'
alias vim='nvim'
alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias pping="httping -x 127.0.0.1:7890"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++11 -Wall'
alias gcc='gcc -std=c11 -Wall'
alias g++='g++ -std=c++11 -Wall'

