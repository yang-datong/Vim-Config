if status is-interactive

#Ubuntu 20.04
xmodmap -e 'keycode 180 = Escape'

set -x PATH $PATH $HOME/.local/bin/
set -x JAVA_HOME $HOME/MySoftWare/android-studio/jbr
set -x ANDROID_NDK_ROOT $HOME/Android/Sdk/ndk/25.1.8937393

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias huya="echo '15886670991, qweasdzxc123'"
alias ip='curl -s -m 5 https://ipleak.net/json/'

alias cl='clear'
alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias cat='batcat -p'
alias vim='nvim'
alias pping="httping -x 127.0.0.1:7890"
alias diff='colordiff -w'
alias python='python3.10'
alias python3='python3.10'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown'
alias apt='sudo apt'
alias docker='sudo docker'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++11 -Wall'
alias gcc='gcc -std=c11 -Wall'
alias g++='g++ -std=c++11 -Wall'
alias set-proxy='source /usr/local/bin/set-proxy'

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
