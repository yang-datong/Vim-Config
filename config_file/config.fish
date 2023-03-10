if status is-interactive
    set -x PATH $PATH /usr/local/Cellar
    set -x PATH $PATH ~/Library/Python/3.9/bin
    set -x PATH $PATH /usr/local/opt/binutils/bin
    set -x PATH $PATH /usr/local/texlive/2022/bin/universal-darwin/
    set -x PATH $PATH /Users/user/Library/Android/sdk/ndk/21.1.6352462

    set -x CLOUD ~/Library/Mobile\ Documents/com~apple~CloudDocs

    set com 'com.ss.android.ugc.aweme'

    set -x JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
    #brew install homebrew/cask-versions/adoptopenjdk8

    alias gdb='/usr/local/Cellar/gdb/12.1/bin/gdb'
    alias phone='echo 15886670991'
    alias cl='clear'
    alias pip='pip3.9'
    alias cat='bat -p'
    alias reboot='sudo reboot'
    alias shutdown='sudo shutdown'
    alias vim='nvim'
    alias rm='trash'
    alias rm-rf='rm -rf'
    alias du='du -sh'
    alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
    alias pping="httping -x 127.0.0.1:7890"
    alias diff='colordiff -w' #brew install colordiff
    alias clang='clang -std=c++11'
    alias clang++='clang++ -std=c++11'
    alias g++='g++ -std=c++11'
    alias gcc='gcc -std=c++11'

end


test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
