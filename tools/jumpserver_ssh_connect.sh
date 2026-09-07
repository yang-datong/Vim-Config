#!/bin/bash

ScriptVersion="1.1"

unset ip
unset code

usage() {
	cat <<EOF
Usage: $(basename "$0") [options] <ip> <otp_code>
   or: $(basename "$0") -i <ip> -c <otp_code>

Connect to target server through JumpServer.

Required arguments:
  <ip>                        Target host IP address
  <otp_code>                  OTP dynamic verification code

Options:
  -i, --ip IP                 Target host IP address
  -c, -o, --code, --otp CODE  OTP dynamic verification code
  -h, --help                  Display this help message and exit
  -d, --debug                 Run script in debug mode (set -x)
  -v, --version               Display script version
EOF
}

main() {
	local ip="$1"
	local code="$2"
	local expect_file="/tmp/jumpserver_ssh_connect.expect"

	cat <<EOF >"$expect_file"
#!/usr/bin/expect

set ip   [lindex \$argv 0]
set code [lindex \$argv 1]

spawn ssh -p 2222 yangjing7@ops@\${ip}@jump.imgo.tv
expect {
	"Are you sure you want to continue connecting*"
	{send "yes\n";exp_continue}
	"password:"
	{send "Zxcvbnm75455..\n"}
}

expect {
	"OTP Code*"
	{send "\$code\n"}
}
interact
EOF

	expect "$expect_file" "$ip" "$code"
}

while getopts ":hdi:c:o:v-:" opt; do
	case "${opt}" in
	h) usage && exit 0 ;;
	d) set -x ;;
	v)
		echo "$0 -- Version $ScriptVersion"
		exit 0
		;;
	i) ip="${OPTARG}" ;;
	c | o) code="${OPTARG}" ;;
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

# Fallback to positional arguments if not specified via options
if [ -z "$ip" ] && [ -n "$1" ]; then
	ip="$1"
	shift
fi

if [ -z "$code" ] && [ -n "$1" ]; then
	code="$1"
	shift
fi

# Validation: ensure both required parameters are provided
if [ -z "$ip" ] || [ -z "$code" ]; then
	echo "Error: Both target IP address and OTP code are required (2 arguments needed)." >&2
	usage >&2
	exit 1
fi

if [ $# -gt 0 ]; then
	echo "Error: Too many arguments: $*" >&2
	usage >&2
	exit 1
fi

main "$ip" "$code"
