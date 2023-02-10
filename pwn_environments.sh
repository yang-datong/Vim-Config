#!/bin/sh

#model
#path
cd ~

#注释
#change pip source
path=${HOME}

:<<!
!
file=$path'/.pip'
if [ ! -d "$file" ]; then
 	mkdir $file
    echo "[global]\nindex-url = https://pypi.douban.com/simple/\n[install]\ntrusted-host = pypi.douban.com" >  ~/.pip/pip.conf
fi

#support 32 bit
sudo dpkg --add-architecture i386
sudo apt update
sudo apt -y install libc6-i386
sudo apt install lib32z1
#git
sudo apt install git
sudo git config --global user.name ‘HNHuangJingYu’
sudo git config --global user.email ‘546229768@qq.com’

#pwndbg
file=$path'/pwndbg'
if [ ! -d "$file" ]; then
 git clone https://github.com/pwndbg/pwndbg $file 
 sudo python3 -m pip install setuptools
 cd $file
 ./setup.sh
fi

#pwngdb
file=$path'/Pwngdb'
if [ ! -d "$file" ]; then
 git clone https://github.com/scwuaptx/Pwngdb.git $file 
fi
#pwntools
sudo apt -y install python3 python3-pip
pip3 install pwntools
#qemu
sudo apt install qemu
sudo apt install qemu-system qemu-user-static binfmt-support
#Depend
sudo apt install -y gcc-arm-linux-gnueabi
sudo apt install qemu libncurses5-dev gcc-arm-linux-gnueabi build-essential  synaptic gcc-aarch64-linux-gnu   git

#ROPgadget
sudo apt install python-capstone
file=$path'/ROPgadget'
if [ ! -d "$file" ]; then
 git clone https://github.com/JonathanSalwan/ROPgadget.git $file 
 cd $file 
 sudo python setup.py install
fi

# install one_gadget
sudo apt -y install ruby
sudo gem install one_gadget

#checksec
sudo cp ~/.local/bin/checksec /usr/bin/

echo "========================================="
echo "=============Good, Enjoy it.============="
echo "========================================="

