#!/bin/bash

ScriptVersion="1.1"

DEFAULT_DOWNLOAD_DIR="${HOME}/Downloads"

unset ip
unset code
unset action
unset remote_path
unset local_path
unset raw_cmd

usage() {
	cat <<EOF
Usage: $(basename "$0") [options] get <ip> <otp_code> <remote_path> [local_path]
   or: $(basename "$0") [options] put <ip> <otp_code> <local_path> [remote_path]
   or: $(basename "$0") [options] <ip> <otp_code> [get|put] <path> [target_path]
   or: $(basename "$0") [options] <ip> <otp_code>

Connect to target server SFTP through JumpServer.

Operations:
  get                         Download file/dir from remote server (default local: ${DEFAULT_DOWNLOAD_DIR}/)
  put                         Upload local file/dir to remote server

Required arguments:
  <ip>                        Target host IP address
  <otp_code>                  OTP dynamic verification code

Options:
  -i, --ip IP                 Target host IP address
  -c, -o, --code, --otp CODE  OTP dynamic verification code
  -a, --action ACTION         Operation: 'get' or 'put'
  -r, --remote PATH           Remote file/directory path
  -l, --local PATH            Local file/directory path (default: ${DEFAULT_DOWNLOAD_DIR}/ for get)
  --cmd CMD                   Raw SFTP command to execute
  -h, --help                  Display this help message and exit
  -d, --debug                 Run script in debug mode (set -x)
  -v, --version               Display script version

Examples:
  # 1. Download remote file to default ${DEFAULT_DOWNLOAD_DIR}/
  $(basename "$0") get 10.200.3.6 123456 /data/app.log

  # 2. Download remote file to specified local path
  $(basename "$0") get 10.200.3.6 123456 /data/app.log /tmp/

  # 3. Upload local file to remote directory
  $(basename "$0") put 10.200.3.6 123456 ./test.txt /data/

  # 4. Interactive SFTP session
  $(basename "$0") 10.200.3.6 123456
EOF
}

main() {
	local ip="$1"
	local code="$2"
	local cmd="$3"
	local expect_file="/tmp/jumpserver_sfpt_connect.expect"

	cat <<EOF >"$expect_file"
#!/usr/bin/expect

set ip   [lindex \$argv 0]
set code [lindex \$argv 1]
set cmd  [lindex \$argv 2]

spawn sftp -P 2222 yangjing7@ops@\${ip}@jump.imgo.tv
expect {
	"Are you sure you want to continue connecting*"
	{send "yes\n";exp_continue}
	"password:"
	{send "Zxcvbnm75455..\n"}
}

expect {
	"*OTP Code*"
	{send "\$code\n"}
}

if {\$cmd ne ""} {
	expect {
		"sftp>"
		{send "\$cmd\n"}
	}
}

interact
EOF

	expect "$expect_file" "$ip" "$code" "$cmd"
}

while getopts ":hdi:c:o:a:r:l:v-:" opt; do
	case "${opt}" in
	h) usage && exit 0 ;;
	d) set -x ;;
	v)
		echo "$0 -- Version $ScriptVersion"
		exit 0
		;;
	i) ip="${OPTARG}" ;;
	c | o) code="${OPTARG}" ;;
	a) action="${OPTARG}" ;;
	r) remote_path="${OPTARG}" ;;
	l) local_path="${OPTARG}" ;;
	-)
		case "${OPTARG}" in
		help) usage && exit 0 ;;
		debug) set -x ;;
		version)
			echo "$0 -- Version $ScriptVersion"
			exit 0
			;;
		ip=*) ip="${OPTARG#*=}" ;;
		ip)
			ip="${!OPTIND}"
			OPTIND=$((OPTIND + 1))
			;;
		code=* | otp=*) code="${OPTARG#*=}" ;;
		code | otp)
			code="${!OPTIND}"
			OPTIND=$((OPTIND + 1))
			;;
		action=*) action="${OPTARG#*=}" ;;
		action)
			action="${!OPTIND}"
			OPTIND=$((OPTIND + 1))
			;;
		remote=*) remote_path="${OPTARG#*=}" ;;
		remote)
			remote_path="${!OPTIND}"
			OPTIND=$((OPTIND + 1))
			;;
		local=*) local_path="${OPTARG#*=}" ;;
		local)
			local_path="${!OPTIND}"
			OPTIND=$((OPTIND + 1))
			;;
		cmd=*) raw_cmd="${OPTARG#*=}" ;;
		cmd)
			raw_cmd="${!OPTIND}"
			OPTIND=$((OPTIND + 1))
			;;
		*)
			echo "Invalid option: --${OPTARG}" >&2
			usage >&2
			exit 1
			;;
		esac
		;;
	:)
		echo "Option -${OPTARG} requires an argument." >&2
		usage >&2
		exit 1
		;;
	*)
		echo "Invalid option: -${OPTARG}" >&2
		usage >&2
		exit 1
		;;
	esac
done
shift $((OPTIND - 1))

# 1. Check if $1 is exact "get" or "put"
if [ -z "$action" ] && { [ "$1" = "get" ] || [ "$1" = "put" ]; }; then
	action="$1"
	shift
fi

# 2. Check if $1 is a raw multi-word command (e.g. "put file dir")
if [ -z "$raw_cmd" ] && [ -z "$action" ] && [[ "$1" =~ ^(put|get|ls|cd|rm|mkdir)\  ]]; then
	raw_cmd="$1"
	shift
fi

# 3. Next positional: Target IP if not set
if [ -z "$ip" ] && [ -n "$1" ]; then
	ip="$1"
	shift
fi

# 4. Next positional: OTP Code if not set
if [ -z "$code" ] && [ -n "$1" ]; then
	code="$1"
	shift
fi

# 5. Check if action is specified after IP/code
if [ -z "$action" ] && [ -z "$raw_cmd" ]; then
	if [ "$1" = "get" ] || [ "$1" = "put" ]; then
		action="$1"
		shift
	elif [ -n "$1" ]; then
		raw_cmd="$1"
		shift
	fi
fi

# 6. Parse path parameters based on action
case "$action" in
get)
	if [ -z "$remote_path" ] && [ -n "$1" ]; then
		remote_path="$1"
		shift
	fi
	if [ -z "$local_path" ] && [ -n "$1" ]; then
		local_path="$1"
		shift
	fi
	[ -z "$local_path" ] && local_path="${DEFAULT_DOWNLOAD_DIR}/"
	mkdir -p "${DEFAULT_DOWNLOAD_DIR}"
	;;
put)
	if [ -z "$local_path" ] && [ -n "$1" ]; then
		local_path="$1"
		shift
	fi
	if [ -z "$remote_path" ] && [ -n "$1" ]; then
		remote_path="$1"
		shift
	fi
	;;
esac

# Validation
if [ -z "$ip" ] || [ -z "$code" ]; then
	echo "Error: Both target IP address and OTP code are required." >&2
	usage >&2
	exit 1
fi

if [ "$action" = "get" ] && [ -z "$remote_path" ]; then
	echo "Error: 'get' operation requires remote file path." >&2
	usage >&2
	exit 1
fi

if [ "$action" = "put" ] && [ -z "$local_path" ]; then
	echo "Error: 'put' operation requires local file path." >&2
	usage >&2
	exit 1
fi

if [ $# -gt 0 ]; then
	echo "Error: Too many arguments: $*" >&2
	usage >&2
	exit 1
fi

# Build SFTP command
sftp_cmd=""
if [ "$action" = "get" ]; then
	sftp_cmd="get $remote_path $local_path"
elif [ "$action" = "put" ]; then
	if [ -n "$remote_path" ]; then
		sftp_cmd="put $local_path $remote_path"
	else
		sftp_cmd="put $local_path"
	fi
elif [ -n "$raw_cmd" ]; then
	sftp_cmd="$raw_cmd"
fi

main "$ip" "$code" "$sftp_cmd"
