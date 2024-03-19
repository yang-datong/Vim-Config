if status is-interactive

#Ubuntu 20.04
xmodmap -e 'keycode 180 = Escape'

set -x PATH $PATH $HOME/.local/bin/
set -x PATH $PATH $HOME/Android/Sdk/ndk/21.4.7075529
set -x PATH $PATH $HOME/MySoftWare/Inkscape
set -x PATH $PATH $HOME/MySoftWare/jadx/bin

set -x SH_FOOT $HOME/sh_foot
set -x CLOUD /run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
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
alias shutdown='sudo shutdown -h now'
alias apt='sudo apt'
alias docker='sudo docker'

#---------- TMP ----------
alias load-frida-hw='adb shell "setenforce 0 && /data/local/tmp/hluPatched-android-arm64 &"'
#---------- TMP ----------

alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
alias diff='colordiff -w' #brew install colordiff
alias clang='clang -std=c11 -Wall'
alias clang++='clang++ -std=c++11 -Wall'
alias gcc='gcc -std=c11 -Wall'
alias g++='g++ -std=c++11 -Wall'
alias set-proxy='source /usr/local/bin/set-proxy'

if test -f $HOME/.autojump/share/autojump/autojump.fish; . $HOME/.autojump/share/autojump/autojump.fish; end
end
