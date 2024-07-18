#!/bin/bash
set -e

ubuntu(){
  sudo apt-get install ca-certificates curl gnupg lsb-release
  curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable" -y
  sudo apt-get -y install docker-ce docker-ce-cli containerd.io
  sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

  sudo systemctl start docker

  #配置源
  #echo "ewogICAgInJlZ2lzdHJ5LW1pcnJvcnMiOiBbCiAgICAgICAgImh0dHA6Ly9odWItbWlycm9yLmMuMTYzLmNvbSIsCiAgICAgICAgImh0dHBzOi8vZG9ja2VyLm1pcnJvcnMudXN0Yy5lZHUuY24iLAogICAgXQp9Cg==" | base64 -d | sudo tee /etc/docker/daemon.json
  
  #重启docker
  sudo service docker restart

  #默认情况下，只有root用户和docker组的用户才能运行Docker命令。我们可以将当前用户添加到docker组，以避免每次使用Docker时都需要使用sudo
  sudo usermod -aG docker $USER && newgrp docker
}

macos(){
  brew install --cask docker
  echo -e "\033[31mInto Dokcer desktop -> Setting-> Advanced-> User\033[0m"
  echo -e "\033[31mAdd $HOME/.docker/bin to PATH env\033[0m"
}

#Check OS System
check_os(){
  case "$(uname)" in
    "Darwin") macos ;;
    "Linux") ubuntu ;;
    *)echo "Windows has not been tested for the time being";exit 1
  esac
}

check_os
