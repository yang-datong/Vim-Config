#Ubuntu

PS1='\033[1;37m\$ \033[0m'
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

shopt -s checkwinsize #在每个命令之后检查窗口大小，并在必要时更新LINES和COLUMNS的值

export PATH=$PATH:$HOME/.local/bin/

export SH_FOOT=$HOME/sh_foot

#Aliases
alias cl='clear'
alias rm='trash'
alias du='du -sh'
alias vim='nvim'
alias mkdir='mkdir -p'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
