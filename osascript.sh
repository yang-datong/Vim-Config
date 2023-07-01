#!/usr/bin/osascript

on act(str)
    tell application str
        activate
    end tell
end act

#弹窗
on dialog(info)
    tell application "Finder"
        say "asd"
    end tell
end dialog
#dialog("nihao")


on open_url(url)
    tell application "Safari"
        set window1 to make new window
        #tell window1
        #    set currTab to active tab of window1
        #    set URL of currTab to url
        #end tell
    end tell
end open_url

#open_url("www.google.com")


#清空回收站
on trashs()
    tell application "Finder"
        empty the trash
    end tell
end trashs


#获得当前页面的网页标题，直接用 name 就行
on get_web_title()
    tell application "Safari"
        tell front document
            name
        end tell
    end tell
end get_web_title

#act("terminal")
#get_web_title()


#输入字符串
on input(str)
    tell application "System Events"
        keystroke str
    end tell
end input
#input("hi!")


#按键
on press(n)
    tell application "System Events"
        key code n
        #key code n using {command down} #multiple key
    end tell
end press
#press(36) #回车
#keystroke
#https://eastmanreference.com/complete-list-of-applescript-key-codes

#鼠标
on mouse()
    tell application "System Events"
        tell process "Safari"
            #entire contents
            #click menu item "文件"
        end tell
    end tell
end mouse

#mouse()



on adb_shell()
    tell application "System Events"
        #tell process "iTerm"
        tell process "terminal"
            keystroke "adb shell"
            delay 1 -- 延时一秒后执行
            key code 36 -- 回车的键位码为36
            delay 1 -- 延时一秒后执行
            keystroke "su"
            delay 1 -- 延时一秒后执行
            key code 36 -- 回车的键位码为36
            delay 1 -- 延时一秒后执行
            keystroke "/data/home/bash"
            delay 1 -- 延时一秒后执行
            key code 36 -- 回车的键位码为36
        end tell
    end tell
end adb_shell



#keystroke
#https://eastmanreference.com/complete-list-of-applescript-key-codes
