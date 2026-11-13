if status is-interactive

set fish_greeting #去除提示

#Ubuntu
set -x PATH $PATH $HOME/.local/bin/
set -x PATH $PATH $HOME/MySoftWare/jadx/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD $HOME/Documents/GoogleDrive
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

#neovim 退出后会改变光标为Block，这里强制切换I
function restore_cursor_shape --on-event fish_prompt
    echo -en "\e[5 q"
end

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end

# 进入 $CLOUD 目录（含子目录）立即异步触发 Google Drive 双向同步
function _cloud_auto_sync --on-variable PWD
    if set -q CLOUD; and test -n "$CLOUD"; and test -x "$HOME/.local/bin/gdrive-bisync.sh"
        if test "$PWD" = "$CLOUD"; or string match -q "$CLOUD/*" -- "$PWD"
            "$HOME/.local/bin/gdrive-bisync.sh" --trigger >/dev/null 2>&1 &
            disown 2>/dev/null
        end
    end
end
_cloud_auto_sync
end
