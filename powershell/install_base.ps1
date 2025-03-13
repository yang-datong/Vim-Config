New-Item -Type file -Force $PROFILE
cp ./config/Microsoft.PowerShell_profile.ps1 $PROFILE


#Install Choco
./install_choco.ps1

choco install gsudo curl wget git python310

#Install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.10 get-pip.py


#mkdir $HOME/.config -> $HOME/AppData/Local
gsudo New-Item -ItemType SymbolicLink -Path $HOME/.config -Target $HOME/AppData/Local -Force


./install_neovim.ps1

#替换WindowsTerminal配置文件
cp ./windows-terminal-settings.json $HOME\.config\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json
