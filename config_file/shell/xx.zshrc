ZSH_THEME="example"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump )

export SH_FOOT=$HOME/sh_foot
export ZSH=$HOME/.oh-my-zsh
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
#alias ip='curl -s -m 5 https://ipleak.net/json/'

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
