#!/bin/sh
git clone https://github.com/NixOS/patchelf ~/patchelf 
cd ~/patchelf
sudo apt-get install autoconf automake libtool
sudo apt-get install libffi-dev
./bootstrap.sh
./configure
make
make check
sudo make install

git clone https://github.com/matrix1001/glibc-all-in-one 

