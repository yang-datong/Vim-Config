source ~/.gdbinit-gef.py
source ~/.pwngdb/pwngdb.py
source ~/.pwngdb/angelheap/gdbinit.py

define hook-run
python
import angelheap
angelheap.init_angelheap()
end
end

define strings 
x/10s $arg0
end

define instruction 
x/10i $arg0
end

define addr 
x/20xg $arg0
end

define cl 
shell clear
end

define ls 
context
par
heapinfo
end

define bin 
heapinfo
end


gef config context.layout "legend regs stack code args source -threads trace extra memory"

set disable-randomization on
