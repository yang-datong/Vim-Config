#Ubuntu

PS1='\033[1;37m\$ \033[0m'
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

shopt -s checkwinsize #在每个命令之后检查窗口大小，并在必要时更新LINES和COLUMNS的值

export PATH=$PATH:$HOME/.local/bin/

export SH_FOOT=$HOME/sh_foot
export TMPDIR=/tmp
export CLOUD=$HOME/Documents/GoogleDrive
export TMPDIR=/tmp/

#Aliases
source $HOME/.common_aliases.sh

# 进入 $CLOUD 目录（含子目录）立即异步触发 Google Drive 双向同步
_cloud_last_pwd=""
_cloud_auto_sync() {
	if [ "$PWD" != "$_cloud_last_pwd" ]; then
		_cloud_last_pwd="$PWD"
		if [ -n "${CLOUD:-}" ] && { [ "$PWD" = "$CLOUD" ] || [[ "$PWD" == "$CLOUD/"* ]]; } && [ -x "$HOME/.local/bin/gdrive-bisync.sh" ]; then
			("$HOME/.local/bin/gdrive-bisync.sh" --trigger >/dev/null 2>&1 &)
		fi
	fi
}
PROMPT_COMMAND="_cloud_auto_sync${PROMPT_COMMAND:+; $PROMPT_COMMAND}"
