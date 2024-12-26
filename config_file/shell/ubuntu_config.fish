if status is-interactive

set fish_greeting #去除提示

#Ubuntu
set -x PATH $PATH $HOME/.local/bin/
set -x PATH $PATH $HOME/Android/Sdk/ndk/21.4.7075529
set -x PATH $PATH $HOME/MySoftWare/jadx/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD /run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
set -x JAVA_HOME $HOME/MySoftWare/android-studio/jbr
set -x ANDROID_NDK_ROOT $HOME/Android/Sdk/ndk/25.1.8937393

alias mkdir='mkdir -p'
alias phone='echo 15886670991'
alias huya="echo '15886670991, qweasdzxc123'"
#alias ip='curl -s -m 5 https://ipleak.net/json/'

alias cl='clear'
alias rm='trash'
alias rm-rf='rm -rf'
alias du='du -sh'
alias cat='batcat -p'
alias vim='nvim'
alias pping="httping -x 127.0.0.1:7890"
alias diff='colordiff -w'

alias pip='pip3.10'
alias pip3='pip3.10'
alias python='python3.10'
alias python3='python3.10'

alias reboot='sudo reboot'
alias shutdown='sudo shutdown -h now'
alias apt='sudo apt'

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c17 -Wall'
alias clang++='clang++ -std=c++14 -Wall'
alias gcc='gcc -std=c17 -Wall'
alias g++='g++ -std=c++14 -Wall'
alias set-proxy='export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890'
alias dis-proxy='export https_proxy= http_proxy= all_proxy='
alias dock-hide='gnome-extensions disable ubuntu-dock@ubuntu.com'
alias dock-show='gnome-extensions enable ubuntu-dock@ubuntu.com'

# ffmpeg
alias ffmpeg-q="ffmpeg -loglevel quiet"
alias ffplay-q="ffplay -loglevel quiet"
alias ffprobe-q="ffprobe -loglevel quiet"

# TODO?
set-proxy

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
