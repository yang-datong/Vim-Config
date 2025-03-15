New-Item -Type file -Force $PROFILE

cp ./config/Microsoft.PowerShell_profile.ps1 $PROFILE
. $PROFILE

#Install Choco
./install_choco.ps1
. $PROFILE

choco install gsudo curl wget git python310

#Install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.10 get-pip.py


#mkdir $HOME/.config -> $HOME/AppData/Local
$link = "$HOME/.config"
if (-not Test-Path -Path $link) {
    gsudo New-Item -ItemType SymbolicLink -Path $link -Target $HOME/AppData/Local -Force
        . $PROFILE
}


./install_neovim.ps1
. $PROFILE

#替换WindowsTerminal配置文件
cp ./config/windows-terminal-settings.json $HOME\.config\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
#cp ./config/windows-terminal-settings.json "$HOME\.config\Microsoft\Windows Terminal\settings.json"
. $PROFILE
