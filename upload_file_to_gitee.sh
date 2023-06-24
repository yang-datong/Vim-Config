#!/bin/bash
ScriptVersion="1.0"

#URL=https://gitee.com/api/v5/swagger#/postV5ReposOwnerRepoContentsPath

unset file
unset directory

upload(){
	if [ $file ];then
		local owner="yang-datong"
		local repo="pwn_16"
		local path="$file"
		local date=$(date +"%Y%m%d%H%M%S")
		local content=$(base64 -i $file)
		local message="upload file $date"

		curl -X POST --header \
			'Content-Type: application/json;charset=UTF-8' \
			"https://gitee.com/api/v5/repos/${owner}/${repo}/contents/${path}" \
			-d "{\"access_token\":\"${YOUR_ACCESS_TOKEN}\",\"content\":\"${content}\",\"message\":\"${message}\"}"
	else
					echo -e "\033[31mTry help\033[0m"
	fi
}


download(){
}

main(){
	upload
	download
}

usage (){
	echo "Usage :  $(basename "$0") [options] [--] argument-1 argument-2

	Options:
	-h, --help                  Display this message
	-d, --debug                 Debug model run
	-p, --posix                 Posix model parse shell command
	-v, --version               Display script version
	-f, --file FILE             Target file
	-D, --directory DIRECTORY   Target directory"

}

while getopts ":hdpvf:D:-:" opt; do
	case "${opt}" in
		h) usage && exit 0;;
		d) set -x ;;
		p) set -o posix ;;
		v) echo "$0 -- Version $ScriptVersion"; exit ;;
		f) file=${OPTARG};;
		D) directory=${OPTARG};;
		-) case "${OPTARG}" in
			help) usage && exit 0;;
			debug)      set -x ;;
			posix)      set -o posix ;;
			version)    echo "$0 -- Version $ScriptVersion"; exit ;;
			file)       file=${!OPTIND}; OPTIND=$((OPTIND+1));;
			directory)  directory=${!OPTIND}; OPTIND=$((OPTIND+1));;
			*)          echo "Invalid option: --${OPTARG}" >&2 && exit 1;;
		esac;;
	:) echo "Option -${OPTARG} requires an argument." >&2 && exit 1;;
	*) echo "Invalid option: -${OPTARG}" >&2 && exit 1;;
esac
done
shift $((OPTIND-1))

YOUR_ACCESS_TOKEN="ae8ce1c62668312fad8987f9d868c7e4"

main "$@"
