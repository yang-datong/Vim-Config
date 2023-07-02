#!/bin/bash

#Info
width=$(adb shell wm size | awk '{print $3}' | awk -F 'x' '{print $1}')
height=$(adb shell wm size | awk '{print $3}' | awk -F 'x' '{print $2}')
center_wid=$(expr $width / 2)
center_hei=$(expr $height / 2)

#Activity Boss
#主页面进入
#home="com.hpbr.bosszhipin/.module.main.activity.MainActivity"
#搜索页面进入
home="com.hpbr.bosszhipin/.search.geek.activity.GeekSearchActivity"
detaile="com.hpbr.bosszhipin/.module.position.BossJobPagerActivity"
chat="com.hpbr.bosszhipin/.chat.single.activity.ChatNewActivity"


cmd(){
	adb shell "$1" || {
		echo -e "\033[31madb [ $1 ] execution failed\033[0m" ; exit
	}
}

check_activity(){
	activity="$1"
	local ret=$(adb shell dumpsys activity top | grep ACTIVITY | tail -1 | awk '{print $2}')
	if [ "$ret" == "$activity" ];then
		echo 0
	else
		echo -1
	fi
}

main(){
	ret=`check_activity $home`
	if [ ${ret} == "0" ];then
		cmd "input tap $center_wid 700"
	fi

	ret=`check_activity $detaile`
	if [ ${ret} == "0" ];then
		cmd "input tap $center_wid 1920"
	fi

	ret=`check_activity $chat`
	if [ ${ret} == "0" ];then
		cmd "input keyevent KEYCODE_BACK"
		cmd "input keyevent KEYCODE_BACK"
	fi

	cmd "input swipe $center_wid $(expr $center_hei + 807 - 327 - 50 ) $center_wid $center_hei"
}


while true;do
	main
	sleep 1
done

