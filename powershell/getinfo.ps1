
$env:USERNAME

echo "登录到计算机的用户"
Get-CimInstance -ClassName Win32_ComputerSystem -Property UserName


echo "本地用户和所有者"
Get-CimInstance -ClassName Win32_OperatingSystem |
    Select-Object -Property NumberOfLicensedUsers,NumberOfUsers,RegisteredUser

echo "所有用户"
Get-LocalUser

echo "BIOS 信息"
Get-CimInstance -ClassName Win32_BIOS

echo "处理器信息"
Get-CimInstance -ClassName Win32_Processor | Select-Object -ExcludeProperty "CIM*"

echo "计算机制造商和型号"
Get-CimInstance -ClassName Win32_ComputerSystem


#echo "已安装的修补程序"
#Get-CimInstance -ClassName Win32_QuickFixEngineering


echo "操作系统版本信息"
Get-CimInstance -ClassName Win32_OperatingSystem |
  Select-Object -Property BuildNumber,BuildType,OSType,ServicePackMajorVersion,ServicePackMinorVersion


echo "可用磁盘空间"
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"

#echo "登录会话信息"
#Get-CimInstance -ClassName Win32_LogonSession


