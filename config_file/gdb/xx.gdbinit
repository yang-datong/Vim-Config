source ~/.gdbinit-gef.py
source ~/.pwngdb/pwngdb.py
source ~/.pwngdb/angelheap/gdbinit.py
source ~/.hide_command.py
#source ~/.../linux-4.4.72/scripts/gdb/vmlinux-gdb.py

#GEF
#1. $ 命令可以直接以不同进制来查看变量值
#2. start 代替 b main , r 命令

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
#par
#heapinfo
end

define bin 
heapinfo
end

define thread-switch-off
set scheduler-locking off
end

define fincycle
until
#在执行完循环体内的最后一条语句之后执行 until, 就会执行完循环体到后面的一个语句停下。
end

define finfor
until
end

define finwhile
until
end

define linked-list
if $argc == 3 || $argc == 4 
set print pretty off
#{
	set $list = ($arg1*)$arg0
	if  $argc == 4
		set $count = $arg3
	end

	while $list 
#{
		if $argc == 4
			if $count <= 0
				loop_break
			end
		end
		print *$list
#tele $list -l 2

		set $list = $list->$arg2
		if $argc == 4
			set $count = $count -1
		end
	end
	#}
#}
else 
#{
	help linked-list
end
#}
end

document linked-list
	usage:listed-list LIST NODE_TYPE NEXT_FIELD [COUNT]
	打印制定个数节点

	LIST:       链表头
	NODE_TYPE:  节点类型
	NEXT_FIELD: 节点后继指针名字
	COUNT:      需要打印个数,没有表示打印全部
end

alias link=linked-list

#trace在大程序的情况下会导致视图卡顿
gef config context.layout "-legend regs -stack code args source threads trace extra memory"

define trace
contex trace
end

set disable-randomization on

#限制字符串输出内容最大为300字符，防止在输出uint8_t* data时，输出内容直接沾满了屏幕
set print elements 300
#set max-value-size unlimited
