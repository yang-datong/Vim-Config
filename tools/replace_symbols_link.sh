#!/bin/bash
set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SH_FOOT="${SH_FOOT:-$(cd "$SCRIPT_DIR/.." && pwd)}"
#ME=/usr/local/bin
ME="$HOME/.local/bin"
if [[ -z "$TMPDIR" ]]; then TMPDIR=/tmp; fi
TMP="$TMPDIR"
self="$(basename "${BASH_SOURCE[0]}")"

main() {
	mkdir -p "$ME"

	# 清理 $ME 下指向 $SCRIPT_DIR 的失效软链
	for link in "$ME"/*; do
		if [[ -L "$link" ]] && [[ ! -e "$link" ]]; then
			local target
			target="$(readlink "$link" || true)"
			if [[ "$target" == "$SCRIPT_DIR"/* ]] || [[ "$target" == "$SH_FOOT/tools"/* ]]; then
				rm -f "$link"
				echo -e "\033[33m Clean broken symlink $link -> $target\033[0m"
			fi
		fi
	done

	# Check file #
	for local_file in "$SCRIPT_DIR"/*; do
		[[ -f "$local_file" || -L "$local_file" ]] || continue
		local file
		file="$(basename "$local_file")"
		[[ "$file" == "$self" ]] && continue
		add_exec_permission "$local_file"
		remove_shell_script_suffix "$local_file"
	done

	# 这里去掉后缀后再重新遍历一次 #
	for local_file in "$SCRIPT_DIR"/*; do
		[[ -f "$local_file" || -L "$local_file" ]] || continue
		local file
		file="$(basename "$local_file")"
		[[ "$file" == "$self" ]] && continue
		if [[ "$file" =~ "systemctl" ]] && [[ "$(uname)" == "Linux" ]]; then
			echo " continue $local_file"
			continue
		fi
		replace_symbols_link "$ME/$file" "$local_file"
	done
}

add_exec_permission() {
	local file="$1"
	if [ ! -L "$file" ] && [ ! -x "$file" ]; then
		chmod +x "$file"
		echo -e "\033[32m$file add exec permission -> $file\033[0m"
	fi
}

remove_shell_script_suffix() {
	local file="$1"
	local file_type="${file##*.}"
	if [ "$file_type" == "sh" ] && [ "$file" != "$file_type" ]; then
		local file_name="${file%.*}"
		mv "$file" "$file_name"
		echo -e "\033[32m$file update to -> $file_name\033[0m"
	fi
}

replace_symbols_link() {
	local file="$1"
	local really_file="$2"
	if [ ! -f "$really_file" ] && [ ! -L "$really_file" ]; then
		echo -e "\033[31m Don't find the $really_file\033[0m"
		exit 1
	fi
	if [[ -L "$file" ]] || [[ -f "$file" ]]; then
		local date
		date=$(date +"%Y%m%d%H%M%S")
		mv "$file" "$TMP/$(basename "$file")_$date"
		echo -e "\033[32m Replace $file done~\033[0m"
	else
		echo -e "\033[33m Add $file done~\033[0m"
	fi
	ln -s "$really_file" "$file"
}

main
