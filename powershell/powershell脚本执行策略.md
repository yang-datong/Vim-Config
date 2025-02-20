powershell脚本执行策略

1. Win+x选择Terminal（Amdin）
2. 执行命令

```powershell
PS C:\Users\hi> Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
PS C:\Users\hi> Get-ExecutionPolicy
```

`Restricted`：默认设置，不允许任何脚本运行。

`AllSigned`：只能运行经过数字证书签名的脚本。

`RemoteSigned`：运行本地脚本不需要数字签名，但运行从网络上下载的脚本必须有数字签名。

`Unrestricted`：允许所有脚本运行。



解除某个脚本文件限制

```powershell
Security warning
Run only scripts that you trust. While scripts from the internet can be useful, this script can potentially harm your
computer. If you trust this script, use the Unblock-File cmdlet to allow the script to run without this warning
message. Do you want to run C:\Users\hi\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1?
[D] Do not run  [R] Run once  [S] Suspend  [?] Help (default is "D"): R
Loading personal and system profiles took 87180ms.

PS C:\Users\hi> Unblock-File -Path "$HOME\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
```

