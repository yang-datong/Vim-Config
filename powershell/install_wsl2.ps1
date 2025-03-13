
# 以管理员身份运行此脚本

#执行命令winver查看windows版本，如果版本低于 1903，则无法安装wsl2
#如果是windows中文+家庭版也无法安装，解决：
#https://github.com/TGSAN/CMWTAT_Digital_Edition

Write-Host "opening WSL ..."
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 启用虚拟机平台功能
Write-Host "open virtual machine platform ..."
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 重启计算机
Write-Host "reboot ?"
#$restart = Read-Host "是否立即重启计算机？(Y/N)"
#if ($restart -eq 'Y' -or $restart -eq 'y') {
#    Restart-Computer -Force
#} else {
#    Write-Host "请手动重启计算机以继续安装。"
#    exit
#}

# 重启后继续执行以下步骤

# 设置 WSL 2 为默认版本
wsl --set-default-version 2

# 安装默认的 Linux 发行版（Ubuntu）
wsl --install -d Ubuntu

Write-Host "WSL 2 installed!"
