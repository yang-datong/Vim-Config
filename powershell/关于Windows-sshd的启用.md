1. 关闭电脑防火墙（这样才能ping的通IP）:

```powershell
Set-NetFirewallProfile -Profile Public -Enabled False
#反之，开启
#Set-NetFirewallProfile -Profile Public -Enabled True
```

2. 设置一个本地用户密码（不是PIN，方便后续ssh连接。如果是用微软账户登录的那就是你微软账户的密码），并查看当前本地用户名：

```powershell
Get-LocaUser
```

3. 默认windows会安装ssh客户端，但是没有服务端，先复制文件到Windows，在Windwos 执行:

```bash
scp -r hi@192.168.0.1:/home/hi/sh_foot/powershell ~/
```

4. 解压~/powershell目录下的OpenSSH-Win64.zip包，然后用管理员用户打开powershell，执行set-executionpolicy RemoteSigned，输入A回车，进入~/powershell/OpenSSH/install_sshd.ps1

5. 启动sshd服务：./load_sshd.ps1

6. 现在Linux应该能够ping到Windows主机了，并能能够连接到22端口，现在需要你输入密码。

7. 好的，还是出现错误：

```
client_loop: send disconnect: Broken pipe
```

这个错误说明你没有使用用户权限启动sshd，你应该执行./load_sshd.ps1，而不是自己手动执行`sshd`

8. 现在进入到了windows的terminal中，那么默认是一个cmd终端，需要修改powershell为默认解释器：

```powershell
New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe" -PropertyType String -Force
```
