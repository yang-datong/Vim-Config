ZSH_THEME="example"

export ZSH=$HOME/.oh-my-zsh

#MacOS
#export PATH=$PATH:$HOME/Library/Android/sdk/ndk/21.1.6352462
export PATH=/opt/homebrew/bin:$PATH #Apple silicon M1芯片安装的brew会在/opt目录下（注意顺序，这里提高了homebrew的优先级，是因为在某些情况下会有重复的软件，但版本不同）
export PATH=$PATH:/Applications/Inkscape.app/Contents/MacOS
export PATH=$PATH:$HOME/Library/Python/3.10/bin
export PATH=$PATH:$HOME/.local/bin/

export SH_FOOT=$HOME/sh_foot
export CLOUD=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
export ANDROID_NDK_ROOT=$HOME/Library/Android/Sdk/ndk/25.1.8937393

#Aliases
source $HOME/.common_aliases.sh

set-proxy

plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump )

source $ZSH/oh-my-zsh.sh

ZSH_HIGHLIGHT_STYLES['command']='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES['parameter']='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES['arg0']='fg=#88c0d0' 
ZSH_HIGHLIGHT_STYLES['single-quoted-argument']='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES['double-quoted-argument']='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES['redirection']='fg=#b48ead,bold'
ZSH_HIGHLIGHT_STYLES['comment']='fg=#4c566a,italic'
ZSH_HIGHLIGHT_STYLES['unknown-token']='fg=#bf616a,bold'
ZSH_HIGHLIGHT_STYLES['path']='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES['path_prefix']='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES['option']='fg=#8fbcbb'
ZSH_HIGHLIGHT_STYLES['default']='default'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4c566a'
zstyle ':completion:*:*:*:*:*' menu select='bg=#434c5e'
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="rs=0:di=38;5;33:ln=38;5;38:mh=00:pi=40;38;5;226:so=38;5;13:do=38;5;5:bd=40;38;5;226:cd=40;38;5;226:or=40;38;5;221:mi=00:su=38;5;1:sg=38;5;16:ca=38;5;9:tw=40;38;5;222:ow=38;5;34:st=40;38;5;13:ex=38;5;121:"
