#!/bin/bash

set -e

ScriptVersion="1.0"

# 注：自 brew 4.0 起，大部分 Homebrew 用户无需设置 homebrew/core 和 homebrew/cask 镜像，只需设置 HOMEBREW_API_DOMAIN 即可。
replace() {
  export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
  brew tap --custom-remote homebrew/core https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git --force
  brew tap --custom-remote homebrew/cask https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git --force
  echo "export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
  brew update
  brew cleanup
}

reset() {
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
  brew untap homebrew/core
  brew untap homebrew/cask
  brew update
}

#旧版本
replace2() {
  brew tap homebrew/core
  git -C "$(brew --repo)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-cask.git
  echo "Homebrew source repositories have been replaced with Tsinghua University mirrors."
  echo "export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
  brew update

}

reset2() {
  git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew.git
  git -C "$(brew --repo homebrew/core)" remote set-url origin https://github.com/Homebrew/homebrew-core.git
  git -C "$(brew --repo homebrew/cask)" remote set-url origin https://github.com/Homebrew/homebrew-cask.git
  echo "Homebrew source repositories have been reset to the official GitHub URLs."
  echo "export HOMEBREW_BOTTLE_DOMAIN=''"
  brew update
}

usage() {
  echo "Usage :  $(basename "$0") [options] [--] argument-1 argument-2

  Options:
  -h, --help                  Display this message
  -d, --debug                 Debug model run
  -p, --posix                 Posix model parse shell command
  -v, --version               Display script version
  --replace                   call replace()
  --reset                     call reset()"

}
if [ $# == 0 ]; then
  usage
  exit
fi

while getopts ":hdpvf:D:-:" opt; do
  case "${opt}" in
  h) usage && exit 0 ;;
  d) set -x ;;
  p) set -o posix ;;
  v)
    echo "$0 -- Version $ScriptVersion"
    exit
    ;;
  f) file=${OPTARG} ;;
  D) directory=${OPTARG} ;;
  -) case "${OPTARG}" in
    help) usage && exit 0 ;;
    debug) set -x ;;
    posix) set -o posix ;;
    version)
      echo "$0 -- Version $ScriptVersion"
      exit
      ;;
    replace)
      replace
      OPTIND=$((OPTIND + 1))
      ;;
    reset)
      reset
      OPTIND=$((OPTIND + 1))
      ;;
    *) echo "Invalid option: --${OPTARG}" >&2 && exit 1 ;;
    esac ;;
  :) echo "Option -${OPTARG} requires an argument." >&2 && exit 1 ;;
  *) echo "Invalid option: -${OPTARG}" >&2 && exit 1 ;;
  esac
done
shift $((OPTIND - 1))
