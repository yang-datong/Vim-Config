if (!([bool]([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")))
{
		Write-Host "no root!!!" -ForegroundColor red
}else{
		Write-Host "Root" -ForegroundColor red
	}
