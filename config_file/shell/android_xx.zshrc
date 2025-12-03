ZSH_THEME="example"

export ZSH=$HOME/.oh-my-zsh

#Adnroid
export PATH=$PATH:$HOME/.local/bin/

export SH_FOOT=$HOME/sh_foot

#Aliases
source $HOME/.common_aliases.sh

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
