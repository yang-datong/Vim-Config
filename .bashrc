export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
# common commands
alias cl='clear'
alias vim='nvim'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ll='ls -lFh'
alias lh='ls -ld .??*'
alias mkdir='mkdir -p'
alias cs='printf "\033c"'

# applications shortcuts
alias ip='curl -s -m 5 https://ipleak.net/json/'

#PS1="\[\033[0;37m\]\$? \$(if [[ \$? == 0 ]]; then echo \"\[\033[0;32m\]\342\234\223\"; else echo \"\[\033[01;31m\]\342\234\227\"; fi) $(if [[ ${EUID} == 0 ]]; then echo '\[\033[0;31m\]\u@\h'; else echo '\[\033[0;32m\]\u@\h'; fi)\[\033[0;34m\] \w \$\[\033[00m\] "
#PS1='\[\e[0;32m\]\w\[\e[0m\] \[\e[0;97m\]\$\[\e[0m\] '
PS1='\e[97m\$\e[96m '

alias ls='ls --color=auto'
alias ll='ls --color=auto -lshaF'
alias grep='grep --color=auto'

export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

shopt -s checkwinsize
#在每个命令之后检查窗口大小，并在必要时
#更新LINES和COLUMNS的值
