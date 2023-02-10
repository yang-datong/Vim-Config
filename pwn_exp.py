#!/usr/bin/env python
# -*- coding: utf-8 -*-
from pwn import *
#import sys

#context.terminal = ['terminator', '-x', 'sh', '-c']
#context.terminal = ['tmux', 'splitw', '-h']
context.log_level = 'debug'
context.arch = 'amd64'
SigreturnFrame(kernel = 'amd64')

binary = "./"

one = [0x45216,0x4526a,0xf02a4,0xf1147]  #2.23(64)
#idx = int(sys.argv[1])

global p
local = 1
if local:
    p = process(binary)
    e = ELF(binary)
    libc = e.libc
else:
    p = remote("node4.buuoj.cn","28506")
    e = ELF(binary)
    libc = e.libc
    #libc = ELF('./libc_32.so.6')

################################ Condfig ############################################
sd = lambda s:p.send(s)
sl = lambda s:p.sendline(s)
rc = lambda s:p.recv(s)
ru = lambda s:p.recvuntil(s)
sa = lambda a,s:p.sendafter(a,s)
sla = lambda a,s:p.sendlineafter(a,s)
it = lambda :p.interactive()

def z(s='b main'):
    gdb.attach(p,s)

def logs(mallocr,string='logs'):
    if(isinstance(mallocr,int)):
       print('\033[1;31;40m%20s-->0x%x\033[0m'%(string,mallocr))
    else:
       print('\033[1;31;40m%20s-->%s\033[0m'%(string,mallocr))

def pa(s=1,t='step'):
    log.success('pause : '+ t +'---> '+str(hex(s)))
    pause()

def info(data,key='info',bit=64):
    if(bit == 64):
      leak = u64(data.ljust(8, b'\0'))
    else:
      leak = u32(data.ljust(4, b'\0'))
    logs(leak,key)
    return leak

################################ Function ############################################
def add(s,c = 'A',p=0):
    sla('>> ','1')
    sla('size?',str(s))
    sa('content?',c)
def dele(i):
    sla('>> ','2')
    sla('index ?',str(i))
def show(i):
    sla('>> ','3')
    sla('index ?',str(i))
################################### Statr ############################################
def pwn():
    
    p.interactive()
################################### End ##############################################
pwn()
while 0:
    try:
        pwn()
        break
    except KeyboardInterrupt:
        p.close()
        p = remote("node4.buuoj.cn","29728")
        #p = process(binary)
    except :
        p.close()
        #p = process(binary)
        p = remote("node4.buuoj.cn","29728")
