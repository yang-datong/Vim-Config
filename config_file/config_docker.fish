if status is-interactive
    export LD_LIBRARY_PATH='./build/lib'
    set com 'com.ss.android.ugc.aweme'
    alias phone='echo 15886670991'
    alias cl='clear'
    alias cat='batcat -p'
    alias vim='nvim'
    alias rm='trash'
    alias rm-rf='rm -rf'
    alias du='du -sh'
    alias ifconfig="ifconfig | grep inet | grep -v 'inet6\|127.0.0.1'"
    alias pping="httping -x 127.0.0.1:7890"
    alias diff='colordiff -w'
    alias clang='clang -std=c11 -Wall'
    alias clang++='clang++ -std=c++11 -Wall'
    alias gcc='gcc -std=c11 -Wall'
    alias g++='g++ -std=c++11 -Wall'
    alias chown='sudo chown'
    alias chmod='sudo chmod'
    alias apt='sudo apt'
end

function fish_prompt
    printf '\e[0;91mdocker-$ '
end
