#!/bin/bash

echo -e "\033[31m0.exit\033[0m"
echo -e "\033[31m1.锁定屏幕\033[0m"
echo -e "\033[31m2.唤醒屏幕\033[0m"
echo -e "\033[31m3.截取屏幕\033[0m"
echo -e "\033[31m4.发送文字\033[0m"

say() {
	read -p "content: " data
	tmp_date=$(date +"%Y%m%d_%H%M%S")
	if [ -z "$data" ]; then
		data="good ,you is by used!"
	fi
	echo "$data" >>$TMPDIR/${tmp_date}.txt && open $TMPDIR/${tmp_date}.txt
}

screen() {
	tmp_date=$(date +"%Y%m%d_%H%M%S")
	screencapture "$CLOUD/demo_${tmp_date}.png"
}

one() {
	#锁定屏幕
	osascript -e 'tell application "Finder" to sleep'
}

two() {
	#锁定屏幕
	#osascript -e 'tell application "Finder" to sleep'
	#唤醒屏幕
	caffeinate -u -t 4
	#唤醒屏幕(no)
	#osascript -e 'tell application "System Events" to key code 123'

	#开机输入秘密
	osascript -e "tell application \"System Events\"" -e "keystroke \"pppp\"" -e "end tell" -e 'tell application "System Events" to key code 36'
	#osascript -e "tell application \"System Events\"" -e "keystroke \"zxcvbnm75455..\"" -e "end tell" -e 'tell application "System Events" to key code 36'
}
main() {
	if [ "$choise" == 1 ]; then
		one
	elif [ "$choise" == 2 ]; then
		two
	elif [ "$choise" == 3 ]; then
		screen
	elif [ "$choise" == 4 ]; then
		say
	elif [ "$choise" == 0 ]; then
		exit
	else
		continue
	fi
}

while true; do
	read -p "input: " choise
	main
done
