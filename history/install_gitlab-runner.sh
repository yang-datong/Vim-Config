#!/bin/bash

ubuntu(){
	pack=gitlab-runner_amd64.deb
	if [ ! -x "$(command -v gitlab-runner)" ];then
		if [ ! -f $pack ];then
			curl -LJO "https://s3.dualstack.us-east-1.amazonaws.com/gitlab-runner-downloads/13.0.0/deb/${pack}"
		fi
		read -p "Input sudo password: " pswd
		echo $pswd | sudo dpkg -i $pack
	fi

	#For http://gitlab1.smart-core.cn/yangjing/test-ci/-/settings/ci_cd#js-runners-settings
	PROJECT_URL=http://gitlab1.smart-core.cn
	RUNNER_TOKEN=HgEEqAo5HtMADjogrraF

# 执行注册命令
#PS D:\gitlab-runner> .\gitlab-runner-windows-amd64.exe register
# 填写gitlab的地址，确保容器内能够顺利访问到该地址
#Enter the GitLab instance URL (for example, https://gitlab.com/):
#http://gitlab1.smart-core.cn
# 填写需要注册的runner token，此处选择shared runner token
#Enter the registration token:
#BHRagrsztQAxdMPP...
#Enter a description for the runner:
#gitlab-runner-02
#Enter tags for the runner (comma-separated):
#Enter optional maintenance note for the runner:
#Enter an executor: custom, docker, docker-windows, docker-ssh, parallels, shell, ssh, docker+machine, kubernetes, virtualbox, docker-ssh+machine:
#docker
#Enter the default Docker image (for example, ruby:2.7):
#docker:latest
# 执行安装命令 .\gitlab-runner-windows-amd64.exe install
# 执行启动命令 .\gitlab-runner-windows-amd64.exe start
}

cc="brew"
#Check OS System
check_os(){
	case "$(uname)" in
		"Darwin") cc="brew";macos;;
		"Linux") cc="sudo apt -y";ubuntu;;
		*)echo "Windows has not been tested for the time being";exit 1
	esac
}

check_os
