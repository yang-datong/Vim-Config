#!/bin/bash

beg=30000
end=99999

log() {
  if [ $# -gt 1 ]; then
    printf "\033[31mParameter can only be one!!!" >&2
    exit
  fi
  tty_wid=$(tput cols)
  line=$(printf "\033[33m%00${tty_wid}d\n" 0 | tr "0" "=")
  string_len=$(echo $1 | wc -c)
  ((tty_wid -= string_len))
  ((tty_wid /= 2))
  echo $line
  printf "%00${tty_wid}d" 0 | tr "0" " "
  printf "\033[91m$1\n"
  echo $line
}

main() {
  local ip=$1
  for ((i = ${beg}; i < ${end}; i++)); do
    read -u6
    {
      ret=$(adb connect ${ip}:${i} | awk '{print $1}')
      echo $i
      if [[ "$ret" == "connected" || "$ret" == "already" ]]; then
        log "${ret}->$i"
        kill $(ps | grep -v grep | grep $0)
      fi
      echo >&6 #给fd6标志加上回车符，即补上了read -u6减去的回车符，
      #可以理解为标记flag完成
    } &
  done
}

#---------------------------thread_config------------------------------
init() {
  thread=12
  fifo="$TMPDIR/demo.fifo"

  mkfifo $fifo
  exec 6<>$fifo #fd6 指向FIFO类型
  rm $fifo

  #在fd6中放置xx个flag（这里为回车符）
  for ((i = 0; i < thread; i++)); do
    echo
  done >&6
}

close() {
  exec 6>&- #关闭fd6
}
#---------------------------thread_config------------------------------

if [ ! $1 ]; then
  echo -e "\033[31mNeed [ip] argument\033[0m"
  exit
fi
init
main
close
