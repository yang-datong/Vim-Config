if status is-interactive

set fish_greeting #去除提示

#MacOS
set -x PATH $PATH /Applications/Inkscape.app/Contents/MacOS
set -x PATH $PATH $HOME/Library/Python/3.10/bin
set -x PATH $PATH $HOME/.local/bin/

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD $HOME/Library/Mobile\ Documents/com~apple~CloudDocs
set -x HOMEBREW_BOTTLE_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
if test (uname -m) = "arm64"
    set -x ANDROID_NDK_HOME /opt/homebrew/share/android-ndk
    #Apple silicon M1芯片安装的brew会在/opt目录下（注意顺序，提高homebrew的优先级，在某些情况下会有重复的软件但版本不同）
    set -x PATH /opt/homebrew/bin $PATH 
else
    set -x ANDROID_NDK_HOME $HOME/Library/Android/Sdk/ndk
end

if test -f $HOME/.AI-Key.txt
    set -x GEMINI_API_KEY (cat $HOME/.AI-Key.txt | grep GEMINI_API_KEY | awk '{print $2}')
    set -x AVANTE_GEMINI_API_KEY $GEMINI_API_KEY
    set -x OPENAI_API_KEY (cat $HOME/.AI-Key.txt | grep OPENAI_API_KEY | awk '{print $2}')
    set -x AVANTE_OPENAI_API_KEY $OPENAI_API_KEY
end

#Aliases
source $HOME/.common_aliases.sh
alias cat='bat -p'
alias gdb='lldb'
alias ldd='otool -L'
alias ida='/Applications/IDA\ Professional\ 9.0.app/Contents/MacOS/ida'

set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
