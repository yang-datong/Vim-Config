if status is-interactive

set fish_greeting #去除提示

#Android
set -x PATH $PATH $HOME/.local/bin/

set -x SH_FOOT $HOME/sh_foot

#Aliases
source $HOME/.common_aliases.sh
alias apt='pkg'

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
