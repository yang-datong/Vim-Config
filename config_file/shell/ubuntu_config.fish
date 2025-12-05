if status is-interactive

set fish_greeting #去除提示

#Ubuntu
set -x PATH $PATH $HOME/.local/bin/
set -x PATH $PATH $HOME/MySoftWare/jadx/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD /run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
set -x ANDROID_NDK_HOME /usr/lib/android-ndk
set -x TMPDIR /tmp

if test -f $HOME/.AI-Key.txt
    set -x GEMINI_API_KEY (cat $HOME/.AI-Key.txt | grep GEMINI_API_KEY | awk '{print $2}')
    set -x AVANTE_GEMINI_API_KEY $GEMINI_API_KEY
    set -x OPENAI_API_KEY (cat $HOME/.AI-Key.txt | grep OPENAI_API_KEY | awk '{print $2}')
    set -x AVANTE_OPENAI_API_KEY $OPENAI_API_KEY
end

#Aliases
source $HOME/.common_aliases.sh
#用于临时别名，某写情况下需要临时添加别名
if test -f $HOME/.tmp_aliases.sh; source $HOME/.tmp_aliases.sh; end
alias cat='batcat -p'
alias apt='sudo apt'
alias ida='wine /home/hi/MySoftWare/IDA_Pro_7.7/ida64.exe'

set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
