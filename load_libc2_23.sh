patchelf --set-interpreter /lib64/2_23-linux.so.2  "$1" &&  patchelf --replace-needed libc.so.6 ~/glibc-all-in-one/libs/2.23-0ubuntu11_amd64/libc-2.23.so  "$1"
