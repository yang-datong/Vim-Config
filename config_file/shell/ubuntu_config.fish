if status is-interactive

set fish_greeting #去除提示

#Ubuntu
set -x PATH $PATH $HOME/.local/bin/
set -x PATH $PATH $HOME/MySoftWare/jadx/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD /run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
set -x ANDROID_NDK_HOME /usr/lib/android-ndk
set -x TMPDIR /tmp

#Aliases
source $HOME/.common_aliases.sh
alias cat='batcat -p'
alias apt='sudo apt'

set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
