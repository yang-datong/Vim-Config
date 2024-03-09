1. 关闭电脑防火墙（这样才能ping的通IP）

2. 设置一个用户密码（不是PIN，方便后续ssh连接。如果是用微软账户登录的那就是你微软账户的密码）

3. 默认windows会安装ssh客户端，但是没有服务端，先复制文件到Windows，在Windwos 执行:
```bash
scp -r hi@192.168.0.1:/home/hi/sh_foot/powershell ~/
```

4. 解压~/powershell目录下的OpenSSH-Win64.zip包，然后用管理员用户打开powershell，执行set-executionpolicy RemoteSigned，输入A回车，进入~/powershell/OpenSSH/install_sshd.ps1

5. 启动sshd服务：./load_sshd.ps1
>如果Linux这边还是连接不上，就手动看看任务管理器的服务中sshd是不是正常运行的


