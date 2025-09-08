#!/bin/bash
set -e

cc="brew"
#Check OS System
check_os() {
	case "$(uname)" in
	"Darwin") cc="brew" ;;
	"Linux") cc="sudo apt -y" ;;
	*)
		echo "Windows has not been tested for the time being"
		exit 1
		;;
	esac
}

main() {
	if [ ! -x "$(command -v aria2c)" ]; then
		check_os
		$cc install aria2
	fi

	if [ ! -d $HOME/.aria2 ]; then
		mkdir $HOME/.aria2
		write
	else
		echo "already exist aria2c"
		exit
	fi
}

write() {
	echo "CiPlhYHorrhycGMKZW5hYmxlLXJwYz10cnVlCiPlhYHorrjmiYDmnInmnaXmupAsIHdlYueVjOmdoui3qOWfn+adg+mZkOmcgOimgQpycGMtYWxsb3ctb3JpZ2luLWFsbD10cnVlCiPlhYHorrjlpJbpg6jorr/pl67vvIxmYWxzZeeahOivneWPquebkeWQrOacrOWcsOerr+WPowpycGMtbGlzdGVuLWFsbD10cnVlCiNSUEPnq6/lj6MsIOS7heW9k+m7mOiupOerr+WPo+iiq+WNoOeUqOaXtuS/ruaUuQpycGMtbGlzdGVuLXBvcnQ9NjgwMQoj5pyA5aSn5ZCM5pe25LiL6L295pWwKOS7u+WKoeaVsCksIOi3r+eUseW7uuiuruWAvDogMwptYXgtY29uY3VycmVudC1kb3dubG9hZHM9NQoj5pat54K557ut5LygCmNvbnRpbnVlPXRydWUKI+WQjOacjeWKoeWZqOi/nuaOpeaVsAptYXgtY29ubmVjdGlvbi1wZXItc2VydmVyPTUKI+acgOWwj+aWh+S7tuWIhueJh+Wkp+Wwjywg5LiL6L2957q/56iL5pWw5LiK6ZmQ5Y+W5Yaz5LqO6IO95YiG5Ye65aSa5bCR54mHLCDlr7nkuo7lsI/mlofku7bph43opoEKbWluLXNwbGl0LXNpemU9MTBNCiPljZXmlofku7bmnIDlpKfnur/nqIvmlbAsIOi3r+eUseW7uuiuruWAvDogNQpzcGxpdD0xNgoj5LiL6L296YCf5bqm6ZmQ5Yi2Cm1heC1vdmVyYWxsLWRvd25sb2FkLWxpbWl0PTAKI+WNleaWh+S7tumAn+W6pumZkOWItgptYXgtZG93bmxvYWQtbGltaXQ9MAoj5LiK5Lyg6YCf5bqm6ZmQ5Yi2Cm1heC1vdmVyYWxsLXVwbG9hZC1saW1pdD0wCiPljZXmlofku7bpgJ/luqbpmZDliLYKbWF4LXVwbG9hZC1saW1pdD0wCiPmlq3lvIDpgJ/luqbov4fmhaLnmoTov57mjqUKI2xvd2VzdC1zcGVlZC1saW1pdD0wCiPmiYDpnIDml7bpl7Qgbm9uZSA8IGZhbGxvYyA/IHRydW5jIMKrIHByZWFsbG9jLCBmYWxsb2Plkox0cnVuY+mcgOimgeaWh+S7tuezu+e7n+WSjOWGheaguOaUr+aMgQpmaWxlLWFsbG9jYXRpb249cHJlYWxsb2MKc2VlZC10aW1lPTAK" | base64 -d >$HOME/.aria2/aria2.conf
	aria2c --conf-path="${HOME}/.aria2/aria2.conf" -D
	echo "done ~ arai2c into ${HOME}"
}

main
