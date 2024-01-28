if status is-interactive

set -x PATH $PATH /usr/local/Cellar
set -x PATH $PATH $HOME/Library/Python/3.9/bin
set -x PATH $PATH /usr/local/opt/binutils/bin
set -x PATH $PATH /usr/local/texlive/2022/bin/universal-darwin/
set -x PATH $PATH $HOME/Library/Android/sdk/ndk/21.1.6352462
set -x PATH $PATH /Applications/Inkscape.app/Contents/MacOS/

set -x CLOUD $HOME/Library/Mobile\ Documents/com~apple~CloudDocs
set -x JAVA_HOME /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
#set -x HOMEBREW_BOTTLE_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias huya="echo '15886670991, qweasdzxc123'"
alias ip='curl -s -m 5 https://ipleak.net/json/'

alias cl='clear'
alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias cat='bat -p'
alias vim='nvim'
alias pping="httping -x 127.0.0.1:7890"
alias pip='pip3.9'
alias python='python3.9'
alias python3='python3.9'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++11 -Wall'
alias gcc='gcc -std=c11 -Wall'
alias g++='g++ -std=c++11 -Wall'
alias set-proxy='source /usr/local/bin/set-proxy'

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
