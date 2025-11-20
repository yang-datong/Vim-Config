ZSH_THEME="example"

export ZSH=$HOME/.oh-my-zsh

#MacOS
export PATH=/opt/homebrew/bin:$PATH #Apple silicon M1芯片安装的brew会在/opt目录下（注意顺序，这里提高了homebrew的优先级，是因为在某些情况下会有重复的软件，但版本不同）
export PATH=$PATH:/Applications/Inkscape.app/Contents/MacOS
export PATH=$PATH:$HOME/Library/Python/3.10/bin
export PATH=$PATH:$HOME/.local/bin/

export SH_FOOT=$HOME/sh_foot
export CLOUD=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
export ANDROID_NDK_HOME=$HOME/Library/Android/Sdk/ndk/25.1.8937393

#Aliases
source $HOME/.common_aliases.sh

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
