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

plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump )

source $ZSH/oh-my-zsh.sh

# Customize zsh-syntax-highlighting colors
ZSH_HIGHLIGHT_STYLES[command]='fg=111'          # Command (e.g., ls, pwd)
ZSH_HIGHLIGHT_STYLES[builtin]='fg=111'          # Built-in commands
ZSH_HIGHLIGHT_STYLES[alias]='fg=111'            # Aliases
ZSH_HIGHLIGHT_STYLES[path]='fg=150'             # Paths
ZSH_HIGHLIGHT_STYLES[precommand]='fg=114'       # Pre-commands (e.g., sudo)
ZSH_HIGHLIGHT_STYLES[argument]='fg=150'         # Arguments
ZSH_HIGHLIGHT_STYLES[redirection]='fg=216'      # Redirection (e.g., >, <)
ZSH_HIGHLIGHT_STYLES[comment]='fg=240'          # Comments
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=203'    # Unknown commands
