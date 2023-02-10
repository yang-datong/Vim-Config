

New-Item -Type file -Force $PROFILE

cp ./Microsoft.PowerShell_profile.ps1 $PROFILE


Write-Host "==========init done========" -ForegroundColor red
