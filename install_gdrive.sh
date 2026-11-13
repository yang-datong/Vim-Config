#!/bin/bash

set -e

REMOTE_NAME="${RCLONE_REMOTE:-gdrive}"
SYNC_DIR="${GDRIVE_SYNC_DIR:-${GDRIVE_MOUNT_DIR:-$HOME/Documents/GoogleDrive}}"
PROXY_URL="${HTTPS_PROXY:-${HTTP_PROXY:-http://127.0.0.1:7890}}"
SYNC_INTERVAL="${GDRIVE_SYNC_INTERVAL:-5min}"
UNIT_BASE="rclone-gdrive-bisync"
SERVICE_NAME="${UNIT_BASE}.service"
TIMER_NAME="${UNIT_BASE}.timer"
WATCH_SERVICE_NAME="rclone-gdrive-watch.service"
SERVICE_FILE="$HOME/.config/systemd/user/${SERVICE_NAME}"
TIMER_FILE="$HOME/.config/systemd/user/${TIMER_NAME}"
WATCH_SERVICE_FILE="$HOME/.config/systemd/user/${WATCH_SERVICE_NAME}"
LEGACY_MOUNT_SERVICE="rclone-gdrive.service"
LEGACY_MOUNT_FILE="$HOME/.config/systemd/user/${LEGACY_MOUNT_SERVICE}"
RCLONE_CONF="$HOME/.config/rclone/rclone.conf"
FORCE_RESYNC=0

usage() {
	cat <<EOF
用法: $0 [选项]

在 Linux (Ubuntu/systemd) 下安装 rclone，完成 Google Drive OAuth 授权，
并配置本地目录 + systemd 用户级定时双向同步（rclone bisync）与 inotify 即时触发监听。
本地文件直接保存在磁盘中，Files 文件管理器可零延迟流畅浏览，打开或修改目录会立即异步触发同步。

选项:
  --sync-dir <PATH>    指定本地同步目录 (默认: $HOME/Documents/GoogleDrive)
  --mount-dir <PATH>   同 --sync-dir（兼容参数）
  --remote <NAME>      指定 rclone remote 名称 (默认: gdrive)
  --interval <TIME>    指定后台双向同步周期 (默认: 5min)
  --proxy <URL>        指定代理地址 (默认: 读取 \$HTTPS_PROXY/\$HTTP_PROXY，否则 http://127.0.0.1:7890)
  --no-proxy           不使用代理
  --resync             强制以 --resync 重新执行一次全量对齐
  --uninstall          停止并移除 systemd 同步服务与定时器（保留本地数据与 rclone.conf）
  --help               显示此帮助信息
EOF
}

check_os() {
	case "$(uname)" in
	"Linux")
		if [[ "$(uname -o)" == "Android" ]]; then
			echo "Termux/Android 环境不支持 systemd 定时同步服务"
			exit 1
		fi
		;;
	"Darwin")
		echo "macOS 默认使用 iCloud Drive (\$CLOUD)，暂未在该脚本中配置 rclone 自动同步"
		exit 1
		;;
	*)
		echo "不支持的操作系统: $(uname)"
		exit 1
		;;
	esac
}

install_deps() {
	local need_apt=0
	if ! command -v rclone >/dev/null 2>&1; then
		need_apt=1
	fi
	if ! command -v flock >/dev/null 2>&1; then
		need_apt=1
	fi
	if ! command -v python3 >/dev/null 2>&1; then
		need_apt=1
	fi

	if [ "$need_apt" -eq 1 ]; then
		echo -e "\033[36m[1/5] 安装 rclone、util-linux 与 python3...\033[0m"
		sudo apt update
		sudo apt install -y rclone util-linux python3
	else
		echo -e "\033[32m[1/5] rclone、flock 与 python3 已就绪 ($(rclone version | head -n 1))\033[0m"
	fi
}

setup_rclone_remote() {
	echo -e "\033[36m[2/5] 检查 rclone remote (${REMOTE_NAME}:)...\033[0m"
	if rclone listremotes 2>/dev/null | grep -qx "${REMOTE_NAME}:"; then
		echo -e "\033[32m已存在 remote '${REMOTE_NAME}:'，跳过 OAuth 授权\033[0m"
	else
		echo -e "\033[33m即将打开浏览器进行 Google Drive OAuth 授权，请在浏览器中登录并允许访问...\033[0m"
		if [ -n "$PROXY_URL" ]; then
			HTTP_PROXY="$PROXY_URL" HTTPS_PROXY="$PROXY_URL" \
				rclone config create "${REMOTE_NAME}" drive scope=drive config_is_local=true
		else
			rclone config create "${REMOTE_NAME}" drive scope=drive config_is_local=true
		fi
	fi

	if [ -f "$RCLONE_CONF" ]; then
		chmod 600 "$RCLONE_CONF"
	fi
}

cleanup_legacy_mount() {
	if systemctl --user list-unit-files 2>/dev/null | grep -q "^${LEGACY_MOUNT_SERVICE}"; then
		echo -e "\033[33m检测到旧版 FUSE 挂载服务 (${LEGACY_MOUNT_SERVICE})，正在停用并迁移为本地同步目录...\033[0m"
		systemctl --user stop "$LEGACY_MOUNT_SERVICE" 2>/dev/null || true
		systemctl --user disable "$LEGACY_MOUNT_SERVICE" 2>/dev/null || true
		rm -f "$LEGACY_MOUNT_FILE"
		systemctl --user daemon-reload
	fi
	if mountpoint -q "$SYNC_DIR" 2>/dev/null; then
		local fusermount_bin
		fusermount_bin="$(command -v fusermount3 || command -v fusermount || true)"
		if [ -n "$fusermount_bin" ]; then
			"$fusermount_bin" -uz "$SYNC_DIR" || true
		fi
	fi
}

setup_wrapper_script() {
	local wrapper_script="$HOME/.local/bin/${REMOTE_NAME}-bisync.sh"
	local watch_script="$HOME/.local/bin/${REMOTE_NAME}-watch.py"
	local workdir="$HOME/.cache/rclone/bisync/${REMOTE_NAME}"
	local rclone_bin
	rclone_bin="$(command -v rclone)"

	echo -e "\033[36m[3/5] 生成双向同步与 inotify 监听脚本...\033[0m"
	mkdir -p "$HOME/.local/bin" "$SYNC_DIR" "$workdir"

	cat >"$wrapper_script" <<EOF
#!/bin/bash
set -euo pipefail

REMOTE_NAME="${REMOTE_NAME}"
SYNC_DIR="${SYNC_DIR}"
WORKDIR="${workdir}"
LOCK_FILE="\${WORKDIR}/bisync.flock"
LAST_SYNC_FILE="\${WORKDIR}/last_sync_ts"
SERVICE_NAME="${SERVICE_NAME}"
RCLONE_BIN="${rclone_bin}"
PROXY_URL="\${HTTPS_PROXY:-\${HTTP_PROXY:-${PROXY_URL}}}"
TRIGGER_COOLDOWN_SEC=15

mkdir -p "\${SYNC_DIR}" "\${WORKDIR}"

if [ "\${1:-}" == "--trigger" ]; then
	if compgen -G "\${WORKDIR}/*.lst-err" >/dev/null; then
		exit 0
	fi
	exec 9>"\${LOCK_FILE}"
	if ! flock -n 9; then
		exit 0
	fi
	if [ -f "\${LAST_SYNC_FILE}" ]; then
		last_ts="\$(cat "\${LAST_SYNC_FILE}" 2>/dev/null || echo 0)"
		now_ts="\$(date +%s)"
		if [ "\${last_ts:-0}" -gt 0 ] 2>/dev/null && [ \$((now_ts - last_ts)) -lt "\${TRIGGER_COOLDOWN_SEC}" ]; then
			exit 0
		fi
	fi
	exec 9>&-
	exec systemctl --user start --no-block "\${SERVICE_NAME}"
fi

exec 9>"\${LOCK_FILE}"
if ! flock -n 9; then
	echo "上一次同步仍在执行中，跳过本轮触发。"
	exit 0
fi

# 已持有排他锁 flock，可安全清理意外中断残留的 rclone .lck 文件
rm -f "\${WORKDIR}"/*.lck

if [ -n "\${PROXY_URL}" ]; then
	export HTTP_PROXY="\${PROXY_URL}"
	export HTTPS_PROXY="\${PROXY_URL}"
	export NO_PROXY="localhost,127.0.0.1"
	proxy_addr="\${PROXY_URL#*://}"
	proxy_addr="\${proxy_addr%%/*}"
	proxy_host="\${proxy_addr%%:*}"
	proxy_port="\${proxy_addr##*:}"
	if [ -n "\${proxy_host}" ] && [ -n "\${proxy_port}" ] && [ "\${proxy_host}" != "\${proxy_port}" ]; then
		if ! (exec 3<>"/dev/tcp/\${proxy_host}/\${proxy_port}") 2>/dev/null; then
			echo "代理 \${PROXY_URL} 暂不可达，跳过本轮同步。"
			exit 0
		fi
	fi
fi

extra_args=()
if [ "\${1:-}" == "--resync" ]; then
	rm -f "\${WORKDIR}"/*.lst-err
	extra_args+=(--resync)
elif compgen -G "\${WORKDIR}/*.lst-err" >/dev/null; then
	echo "错误：检测到上次同步异常中止残留的 .lst-err 状态文件（可能存在双端不同步或超限删除）。" >&2
	echo "为防止 --resync 误将已删文件重新传回，已自动暂停。请确认以哪一侧为准后再恢复：" >&2
	echo "  - 若以云端为准清理本地多余文件: rclone sync \${REMOTE_NAME}: \${SYNC_DIR} --drive-skip-gdocs && \${0} --resync" >&2
	echo "  - 若确认双向合并覆盖: \${0} --resync" >&2
	exit 1
elif ! compgen -G "\${WORKDIR}/*.path1.lst" >/dev/null || ! compgen -G "\${WORKDIR}/*.path2.lst" >/dev/null; then
	if compgen -G "\${WORKDIR}/*.lst*" >/dev/null || [ -n "\$(ls -A "\${SYNC_DIR}")" ]; then
		echo "错误：基线索引不完整且本地目录非空，已拒绝自动 --resync 以防误上传已删文件。" >&2
		echo "请确认以哪一侧为准后再恢复：" >&2
		echo "  - 若以云端为准清理本地多余文件: rclone sync \${REMOTE_NAME}: \${SYNC_DIR} --drive-skip-gdocs && \${0} --resync" >&2
		echo "  - 若确认双向合并覆盖: \${0} --resync" >&2
		exit 1
	fi
	echo "本地目录为空且无历史索引，自动执行首次 --resync 初始化同步..."
	extra_args+=(--resync)
fi

rc=0
"\${RCLONE_BIN}" bisync "\${REMOTE_NAME}:" "\${SYNC_DIR}" \\
	--workdir "\${WORKDIR}" \\
	--drive-skip-gdocs \\
	--transfers 4 \\
	--checkers 8 \\
	--drive-chunk-size 32M \\
	--stats 30s \\
	--stats-log-level NOTICE \\
	--log-level INFO \\
	\${extra_args[@]+"\${extra_args[@]}"} || rc=\$?

date +%s >"\${LAST_SYNC_FILE}"
exit "\${rc}"
EOF
	chmod +x "$wrapper_script"

	cat >"$watch_script" <<'PYEOF'
#!/usr/bin/env python3
import ctypes
import fcntl
import glob
import os
import select
import signal
import struct
import subprocess
import sys
import time

SYNC_DIR = os.path.abspath(os.environ.get("SYNC_DIR", "/home/hi/Documents/GoogleDrive"))
WORKDIR = os.path.abspath(os.environ.get("WORKDIR", "/home/hi/.cache/rclone/bisync/gdrive"))
SERVICE_NAME = os.environ.get("SERVICE_NAME", "rclone-gdrive-bisync.service")
LOCK_FILE = os.path.join(WORKDIR, "bisync.flock")
LAST_SYNC_FILE = os.path.join(WORKDIR, "last_sync_ts")

OPEN_COOLDOWN_SEC = float(os.environ.get("OPEN_COOLDOWN_SEC", "30"))
CHANGE_DEBOUNCE_SEC = float(os.environ.get("CHANGE_DEBOUNCE_SEC", "2"))
POST_SYNC_GRACE_SEC = float(os.environ.get("POST_SYNC_GRACE_SEC", "4"))

IN_CLOSE_WRITE = 0x00000008
IN_OPEN = 0x00000020
IN_MOVED_FROM = 0x00000040
IN_MOVED_TO = 0x00000080
IN_CREATE = 0x00000100
IN_DELETE = 0x00000200
IN_DELETE_SELF = 0x00000400
IN_MOVE_SELF = 0x00000800
IN_IGNORED = 0x00008000
IN_ONLYDIR = 0x01000000
IN_ISDIR = 0x40000000

IN_NONBLOCK = 0o4000
IN_CLOEXEC = 0o2000000

WATCH_MASK = (
    IN_OPEN
    | IN_CLOSE_WRITE
    | IN_MOVED_FROM
    | IN_MOVED_TO
    | IN_CREATE
    | IN_DELETE
    | IN_DELETE_SELF
    | IN_MOVE_SELF
    | IN_ONLYDIR
)

libc = ctypes.CDLL("libc.so.6", use_errno=True)
libc.inotify_init1.argtypes = [ctypes.c_int]
libc.inotify_init1.restype = ctypes.c_int
libc.inotify_add_watch.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_uint32]
libc.inotify_add_watch.restype = ctypes.c_int

running = True


def _stop(_signum, _frame):
    global running
    running = False


signal.signal(signal.SIGTERM, _stop)
signal.signal(signal.SIGINT, _stop)


def is_ignored_name(name: str) -> bool:
    if not name:
        return False
    if name.startswith(".goutputstream-"):
        return True
    if name.endswith((".swp", ".swx", ".tmp", "~", ".part", ".crdownload")):
        return True
    return False


def is_sync_locked() -> bool:
    os.makedirs(WORKDIR, exist_ok=True)
    fd = os.open(LOCK_FILE, os.O_CREAT | os.O_RDWR, 0o644)
    try:
        fcntl.flock(fd, fcntl.LOCK_EX | fcntl.LOCK_NB)
        fcntl.flock(fd, fcntl.LOCK_UN)
        return False
    except BlockingIOError:
        return True
    finally:
        os.close(fd)


def get_last_sync_ts() -> float:
    try:
        with open(LAST_SYNC_FILE, "r", encoding="utf-8") as f:
            return float(f.read().strip() or "0")
    except OSError:
        return 0.0
    except ValueError:
        return 0.0


def has_err_state() -> bool:
    return bool(glob.glob(os.path.join(WORKDIR, "*.lst-err")))


def add_watch_tree(fd: int, root: str, wd_to_path: dict[int, str], path_to_wd: dict[str, int]) -> None:
    dirs_to_watch: list[str] = []
    for dirpath, dirnames, _ in os.walk(root, followlinks=False):
        dirnames[:] = [d for d in dirnames if not os.path.islink(os.path.join(dirpath, d))]
        if dirpath not in path_to_wd:
            dirs_to_watch.append(dirpath)
    for dirpath in dirs_to_watch:
        wd = libc.inotify_add_watch(fd, dirpath.encode("utf-8"), WATCH_MASK)
        if wd >= 0:
            wd_to_path[wd] = dirpath
            path_to_wd[dirpath] = wd


def trigger_sync(reason: str) -> None:
    if has_err_state():
        return
    if is_sync_locked():
        return
    print(f"[gdrive-watch] {reason} -> triggering {SERVICE_NAME}", flush=True)
    subprocess.run(
        ["systemctl", "--user", "start", "--no-block", SERVICE_NAME],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
        check=False,
    )


def main() -> int:
    os.makedirs(SYNC_DIR, exist_ok=True)
    os.makedirs(WORKDIR, exist_ok=True)

    fd = libc.inotify_init1(IN_NONBLOCK | IN_CLOEXEC)
    if fd < 0:
        err = ctypes.get_errno()
        print(f"inotify_init1 failed: {os.strerror(err)}", file=sys.stderr)
        return 1

    wd_to_path: dict[int, str] = {}
    path_to_wd: dict[str, int] = {}
    add_watch_tree(fd, SYNC_DIR, wd_to_path, path_to_wd)
    print(f"[gdrive-watch] watching {len(wd_to_path)} dirs under {SYNC_DIR}", flush=True)

    pending_change_at: float | None = None
    last_trigger_at: float = 0.0
    suppressed_open_until: dict[str, float] = {}

    try:
        while running:
            timeout = 1.0
            if pending_change_at is not None:
                rem = pending_change_at - time.time()
                timeout = max(0.05, min(1.0, rem))

            readable, _, _ = select.select([fd], [], [], timeout)
            now = time.time()
            locked = is_sync_locked()
            last_sync = get_last_sync_ts()

            if suppressed_open_until:
                suppressed_open_until = {p: exp for p, exp in suppressed_open_until.items() if exp > now}

            if locked:
                pending_change_at = None

            if readable:
                try:
                    buf = os.read(fd, 65536)
                except BlockingIOError:
                    buf = b""

                offset = 0
                should_trigger_open = False
                open_target = ""

                while offset + 16 <= len(buf):
                    wd, mask, _cookie, name_len = struct.unpack_from("iIII", buf, offset)
                    offset += 16
                    raw_name = buf[offset : offset + name_len]
                    offset += name_len
                    name = raw_name.rstrip(b"\x00").decode("utf-8", "replace")

                    parent = wd_to_path.get(wd)
                    if mask & IN_IGNORED:
                        old_path = wd_to_path.pop(wd, None)
                        if old_path:
                            path_to_wd.pop(old_path, None)
                        continue

                    if parent and (mask & (IN_CREATE | IN_MOVED_TO)) and (mask & IN_ISDIR) and name:
                        subpath = os.path.join(parent, name)
                        if os.path.isdir(subpath) and not os.path.islink(subpath):
                            suppressed_open_until[subpath] = now + 1.0
                            add_watch_tree(fd, subpath, wd_to_path, path_to_wd)

                    if locked or has_err_state():
                        continue

                    if (mask & IN_OPEN) and (mask & IN_ISDIR):
                        target = os.path.join(parent or SYNC_DIR, name) if name else (parent or SYNC_DIR)
                        if suppressed_open_until.get(target, 0.0) > now:
                            continue
                        if (now - last_sync >= OPEN_COOLDOWN_SEC) and (now - last_trigger_at >= 10.0):
                            should_trigger_open = True
                            open_target = target
                        continue

                    if mask & (IN_CLOSE_WRITE | IN_DELETE | IN_MOVED_FROM | IN_MOVED_TO) or (
                        (mask & IN_CREATE) and (mask & IN_ISDIR)
                    ):
                        if not is_ignored_name(name) and (now - last_sync >= POST_SYNC_GRACE_SEC):
                            pending_change_at = now + CHANGE_DEBOUNCE_SEC

                if should_trigger_open:
                    pending_change_at = None
                    last_trigger_at = now
                    trigger_sync(f"directory opened: {open_target}")

            if pending_change_at is not None and time.time() >= pending_change_at:
                pending_change_at = None
                now = time.time()
                if not is_sync_locked() and (now - get_last_sync_ts() >= POST_SYNC_GRACE_SEC):
                    last_trigger_at = now
                    trigger_sync("local filesystem change")

    finally:
        os.close(fd)

    return 0


if __name__ == "__main__":
    sys.exit(main())
PYEOF
	chmod +x "$watch_script"
}

setup_gtk_bookmark() {
	local bookmarks_file="$HOME/.config/gtk-3.0/bookmarks"
	local dir_uri="file://${SYNC_DIR}"
	local dir_label
	dir_label="$(basename "$SYNC_DIR")"

	if [ -d "$HOME/.config/gtk-3.0" ]; then
		touch "$bookmarks_file"
		if ! grep -qF "${dir_uri}" "$bookmarks_file" 2>/dev/null; then
			echo "${dir_uri} ${dir_label}" >>"$bookmarks_file"
			echo -e "\033[32m已添加 Files 侧边栏书签: ${dir_label}\033[0m"
		fi
	fi

	# 恢复 Nautilus 本地目录项目计数（本地真实目录无需关闭）
	if command -v gsettings >/dev/null 2>&1; then
		if gsettings list-schemas 2>/dev/null | grep -qx "org.gnome.nautilus.preferences"; then
			gsettings set org.gnome.nautilus.preferences show-directory-item-counts 'local-only' 2>/dev/null || true
		fi
	fi
}

setup_systemd_units() {
	local wrapper_script="$HOME/.local/bin/${REMOTE_NAME}-bisync.sh"
	local watch_script="$HOME/.local/bin/${REMOTE_NAME}-watch.py"
	local workdir="$HOME/.cache/rclone/bisync/${REMOTE_NAME}"
	local python_bin
	python_bin="$(command -v python3)"

	echo -e "\033[36m[4/5] 配置 systemd 定时双向同步与即时监听 (${SERVICE_NAME} + ${TIMER_NAME} + ${WATCH_SERVICE_NAME})...\033[0m"
	mkdir -p "$HOME/.config/systemd/user"

	local proxy_env=""
	if [ -n "$PROXY_URL" ]; then
		proxy_env=$(
			cat <<EOF
Environment=HTTP_PROXY=${PROXY_URL}
Environment=HTTPS_PROXY=${PROXY_URL}
Environment=NO_PROXY=localhost,127.0.0.1
EOF
		)
	fi

	cat >"$SERVICE_FILE" <<EOF
[Unit]
Description=Rclone Bidirectional Sync for Google Drive (${REMOTE_NAME}:)
After=network-online.target
Wants=network-online.target

[Service]
Type=oneshot
TimeoutStartSec=0
${proxy_env}
ExecStart=${wrapper_script}
EOF

	cat >"$TIMER_FILE" <<EOF
[Unit]
Description=Periodic Google Drive Bisync Timer (${REMOTE_NAME}:)

[Timer]
OnBootSec=1min
OnUnitActiveSec=${SYNC_INTERVAL}
Persistent=true

[Install]
WantedBy=timers.target
EOF

	cat >"$WATCH_SERVICE_FILE" <<EOF
[Unit]
Description=Google Drive Instant Sync Watcher (inotify on ${SYNC_DIR})
After=default.target

[Service]
Type=simple
Environment=SYNC_DIR=${SYNC_DIR}
Environment=WORKDIR=${workdir}
Environment=SERVICE_NAME=${SERVICE_NAME}
ExecStart=${python_bin} ${watch_script}
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=default.target
EOF

	systemctl --user daemon-reload
	systemctl --user enable --now "$TIMER_NAME" "$WATCH_SERVICE_NAME"

	if [ "$FORCE_RESYNC" -eq 1 ]; then
		echo -e "\033[33m以 --resync 触发后台全量对齐...\033[0m"
		if systemctl --user is-active --quiet "$SERVICE_NAME" 2>/dev/null; then
			systemctl --user stop "$SERVICE_NAME" || true
		fi
		rm -f "$HOME/.cache/rclone/bisync/${REMOTE_NAME}"/*.lst*
		systemd-run --user --collect --no-block --unit="${UNIT_BASE}-resync" "$wrapper_script" --resync
	else
		systemctl --user start --no-block "$SERVICE_NAME"
	fi
}

verify_sync() {
	echo -e "\033[36m[5/5] 验证同步服务与定时器状态...\033[0m"
	sleep 2
	systemctl --user list-timers "$TIMER_NAME" --no-pager || true
	systemctl --user status "$WATCH_SERVICE_NAME" "$SERVICE_NAME" --no-pager -l || true
	echo -e "\033[32m配置完成: ${REMOTE_NAME}: <-> ${SYNC_DIR} (定时周期: ${SYNC_INTERVAL} + 开目/改动即时触发)\033[0m"
	echo "首次全量对齐正在后台运行，已下载的文件可立即在本地零延迟打开。"
	echo "常用管理命令:"
	echo "  journalctl --user -u ${SERVICE_NAME} -f           # 查看实时同步进度与日志"
	echo "  journalctl --user -u ${WATCH_SERVICE_NAME} -f     # 查看目录打开/变更触发日志"
	echo "  systemctl --user start --no-block ${SERVICE_NAME} # 立即手动触发一次同步"
	echo "  systemctl --user status ${TIMER_NAME}             # 查看定时器状态"
}

uninstall_service() {
	local wrapper_script="$HOME/.local/bin/${REMOTE_NAME}-bisync.sh"
	local watch_script="$HOME/.local/bin/${REMOTE_NAME}-watch.py"
	echo "停止并移除 ${TIMER_NAME} / ${SERVICE_NAME} / ${WATCH_SERVICE_NAME}..."
	systemctl --user stop "$TIMER_NAME" "$SERVICE_NAME" "$WATCH_SERVICE_NAME" 2>/dev/null || true
	systemctl --user disable "$TIMER_NAME" "$WATCH_SERVICE_NAME" 2>/dev/null || true
	rm -f "$TIMER_FILE" "$SERVICE_FILE" "$WATCH_SERVICE_FILE" "$wrapper_script" "$watch_script"
	cleanup_legacy_mount
	systemctl --user daemon-reload
	echo "已移除双向同步服务（${RCLONE_CONF} 与 ${SYNC_DIR} 本地文件已保留）"
}

main() {
	local action="install"
	while [ $# -gt 0 ]; do
		case "$1" in
		--sync-dir | --mount-dir)
			[ $# -lt 2 ] && { echo "缺少 $1 参数值"; exit 1; }
			SYNC_DIR="$2"
			shift 2
			;;
		--remote)
			[ $# -lt 2 ] && { echo "缺少 --remote 参数值"; exit 1; }
			REMOTE_NAME="$2"
			shift 2
			;;
		--interval)
			[ $# -lt 2 ] && { echo "缺少 --interval 参数值"; exit 1; }
			SYNC_INTERVAL="$2"
			shift 2
			;;
		--proxy)
			[ $# -lt 2 ] && { echo "缺少 --proxy 参数值"; exit 1; }
			PROXY_URL="$2"
			shift 2
			;;
		--no-proxy)
			PROXY_URL=""
			shift
			;;
		--resync)
			FORCE_RESYNC=1
			shift
			;;
		--uninstall)
			action="uninstall"
			shift
			;;
		--help | -h)
			usage
			exit 0
			;;
		*)
			echo "未知参数: $1"
			usage
			exit 1
			;;
		esac
	done

	check_os
	if [ "$action" == "uninstall" ]; then
		uninstall_service
		exit 0
	fi

	install_deps
	setup_rclone_remote
	cleanup_legacy_mount
	setup_wrapper_script
	setup_gtk_bookmark
	setup_systemd_units
	verify_sync
}

main "$@"
