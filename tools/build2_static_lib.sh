#!/bin/bash
ScriptVersion="1.0"

unset file

main(){
	if [ ! $file ];then
		file="$1"
	fi
	if [ -z "$file" ];then
		echo -e "\033[31mNeed file\033[0m";exit
	fi
	local perfix=${file%.*}
	local suffix=${file##*.}

  local cc="gcc"
  if [ "$suffix" == "c" ];then
    cc="gcc"
  elif [ "$suffix" == "cpp" ];then
    cc="g++"
  else
		echo -e "\033[31mFile format error\033[0m";exit
  fi
  $cc -c $file
  ar rcs "lib${perfix}.a" "${perfix}.o"
  echo "use -> $cc xxx.c -L. -l${perfix}"
  rm "${perfix}.o"
}

usage (){
  echo "Usage :  $(basename "$0") [options] [--] file

  Options:
  -h, --help                  Display this message
  -d, --debug                 Debug model run
  -p, --posix                 Posix model parse shell command
  -v, --version               Display script version
  -f, --file FILE             Target file "

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

main "$@"
