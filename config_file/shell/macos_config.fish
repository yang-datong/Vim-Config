if status is-interactive

set fish_greeting #去除提示

#MacOS
#set -x PATH $PATH $HOME/Library/Android/sdk/ndk/21.1.6352462
set -x PATH /opt/homebrew/bin $PATH #Apple silicon M1芯片安装的brew会在/opt目录下（注意顺序，这里提高了homebrew的优先级，是因为在某些情况下会有重复的软件，但版本不同）
set -x PATH $PATH /Applications/Inkscape.app/Contents/MacOS
set -x PATH $PATH $HOME/Library/Python/3.10/bin
set -x PATH $PATH $HOME/.local/bin/

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD $HOME/Library/Mobile\ Documents/com~apple~CloudDocs
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
set -x ANDROID_NDK_ROOT $HOME/Library/Android/Sdk/ndk

#Aliases
source $HOME/.common_aliases.sh
alias cat='bat -p'
alias gdb='lldb'
alias ldd='otool -L'
alias ida='/Applications/IDA\ Professional\ 9.0.app/Contents/MacOS/ida'

set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
