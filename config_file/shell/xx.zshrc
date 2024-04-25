SHELL=/usr/bin/zsh
export LD_LIBRARY_PATH=/home/hi/home/railBroadcastProfessionalServer/BusinessServer/pjsip/lib

#export http_proxy=http://127.0.0.1:8889
#export https_proxy=$http_proxy

export PATH=$PATH:/usr/local/Cellar
export PATH=$PATH:$HOME/Library/Python/3.9/bin
export PATH=$PATH:/usr/local/opt/binutils/bin
export PATH=$PATH:/usr/local/texlive/2022/bin/universal-darwin/
export PATH=$PATH:$HOME/Library/Android/sdk/ndk/21.1.6352462
export PATH=$PATH:$HOME/tools/nvim-linux64/bin
export PATH=$PATH:$HOME/tools/clangd_16.0.2/bin
export PATH=$PATH:$HOME/tools/cmake-3.26.4/bin
export PATH=$PATH:$HOME/tools/node-v18.16.1-linux-x64/bin
export PATH=$PATH:$HOME/.local/bin/

export ZSH=$HOME/.oh-my-zsh
export CLOUD=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump )  #插件

#[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

ZSH_THEME="example"

alias mkdir='mkdir -p'
alias open='xdg-open'
#alias gdb='/usr/local/Cellar/gdb/12.1/bin/gdb'
alias phone='echo 15886670991'
alias axel='axel -n 16'
alias ip='curl -s -m 5 https://ipleak.net/json/'
alias cl='clear'
#alias pip='pip3.9'
#alias python='python3.9'
#alias python3='python3.9'
#alias cat='bat -p'
alias docker='sudo docker'
alias apt='sudo apt'
alias chmod='sudo chmod'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'
alias vim='nvim'
#alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias pping="httping -x 127.0.0.1:8889"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++11 -Wall'
alias gcc='gcc -std=c14 -Wall'
alias g++='g++ -std=c++14 -Wall'

source $ZSH/oh-my-zsh.sh
