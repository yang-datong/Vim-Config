New-Item -Type file -Force $PROFILE
cp ./config/Microsoft.PowerShell_profile.ps1 $PROFILE

choco install curl wget git python310

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python3.10 get-pip.py
