if status is-interactive

set fish_greeting #去除提示

#Ubuntu
#set -x PATH $PATH $HOME/Android/Sdk/ndk/21.4.7075529
set -x PATH $PATH $HOME/.local/bin/
set -x PATH $PATH $HOME/MySoftWare/jadx/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD /run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
set -x JAVA_HOME $HOME/MySoftWare/android-studio/jbr
set -x ANDROID_NDK_ROOT $HOME/Android/Sdk/ndk/25.1.8937393

#Aliases
source $HOME/.common_aliases.sh
alias cat='batcat -p'
alias apt='sudo apt'

set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
