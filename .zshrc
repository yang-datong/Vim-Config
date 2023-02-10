export ZSH=$HOME/.oh-my-zsh

export PATH=$PATH:/usr/local/Cellar
export PATH=$PATH:/Users/hnhuangjingyu/Library/Python/3.9/bin

#export PATH=$PATH:/usr/local/opt/llvm/include
export PATH=$PATH:/usr/local/opt/binutils/bin
#export PATH="/usr/local/opt/llvm/bin:$PATH"

export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump )  #插件

[[ -s ~/.autojump/etc/profile.d/autojump.sh ]] && . ~/.autojump/etc/profile.d/autojump.sh

ZSH_THEME="kennethreitz"  #Mac
#ZSH_THEME="arrow"  #箭头
#ZSH_THEME="awesomepanda"  #也可以
#ZSH_THEME="robbyrussell"  #最好看的主题
#ZSH_THEME="candy"   #带时间
#ZSH_THEME="steeef"   #命令在下面

alias cl='clear'
alias pip='pip3.9'
alias cat='bat -p'
alias reboot='sudo reboot'
alias shutdown='sudo shutdown'
alias vim='nvim'
alias rm=trash

trash(){
    del_date=`date +%Y%m%d%H%M%S`
    # 循m多个文件
    for arg in "$@"
    do
       mv $arg ~/.Trash/$arg-${del_date}
    done
}

source $ZSH/oh-my-zsh.sh
