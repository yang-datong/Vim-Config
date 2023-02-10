#系统自动更新禁用的反向操作
	Write-Output "start to enable windows update"
	Start-Service -Name "Windows Update"
	#组策略1：禁用指定internal Microsoft更新服务位置
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "UseWUServer" -Type DWord -Value 0
	#组策略2：启动配置自动更新
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type DWord -Value 0
	#组策略3：不删除使用所有 Windows 更新功能的访问权限
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "SetDisableUXWUAccess" -Type DWord -Value 0
	
	#组策略1：恢复错误配置
	If (!(Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate")) {
		New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Force | Out-Null
	}
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUServer" -Type String -Value ""
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "WUStatusServer" -Type String -Value ""
	#组策略4：允许更新延迟策略对 Windows 更新执行扫描
	Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" -Name "DisableDualScan" -Type DWord -Value 0
	#组策略5：策略名称：指定可选组件安装和组件修复的设置
	If (!(Test-Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing")) {
		New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing" -Force | Out-Null
	}
	Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing" -Name "RepairContentServerSource"
	Remove-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Policies\Servicing" -Name "UseWindowsUpdate"
	Write-Output "enable windows update successful"
