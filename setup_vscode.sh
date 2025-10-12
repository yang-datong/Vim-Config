#!/bin/bash

# ==============================================================================
# VS Code C/C++ CMake 环境自动配置脚本
#
# 用法:
#   ./setup_vscode.sh <platform>
#
# <platform> 可以是以下之一:
#   linux   - 为 Linux (GCC/GDB) 配置
#   macos   - 为 macOS (Clang/LLDB) 配置
#   windows - 为 Windows (MinGW/GDB) 配置
#
# 示例:
#   ./setup_vscode.sh linux
#
#   这个配置中，使用Cmake:
#   1. 首次配置:
#   打开命令面板 (Ctrl+Shift+P)。
#   输入并选择 Tasks: Run Task。
#   选择 CMake Configure。
#   这会在项目根目录下创建一个 build 文件夹，并生成 Makefile (或 Ninja 文件) 和 compile_commands.json。
#
#   2. 编译项目并运行:
#   使用快捷键 Ctrl+Shift+B (或者通过命令面板运行 Tasks: Build And Run)。
#   VS Code 将执行 CMake Build 任务来编译并运行可执行文件。
#
#   3. 调试项目:
#   在 main.cpp 文件中设置一个断点。
#   切换到“运行和调试”侧边栏 ( Ctrl+Shift+D )。
#   点击绿色的“开始调试”按钮（或按 F5）。
#   VS Code 会启动调试器并在断点处暂停。
# ==============================================================================

# --- 在这里修改 CMake 可执行文件目标名称 ---
EXECUTABLE_NAME="a.out"

# --- 检查输入参数 ---
if [ "$#" -ne 1 ]; then
	echo "错误: 需要一个平台参数。"
	echo "用法: $0 {linux|macos|windows}"
	exit 1
fi

PLATFORM=$1

# --- 根据平台设置变量 ---
case $PLATFORM in
"linux")
	C_CPP_NAME="Linux"
	# 对于 Linux, 通常是 gcc
	COMPILER_PATH="/usr/bin/gcc"
	INTELLISENSE_MODE="linux-gcc-x64"
	# 使用 gdb
	DEBUGGER_MI_MODE="gdb"
	EXECUTABLE_SUFFIX=""
	# Linux shell 使用 && 连接命令
	COMMAND_SEPARATOR="&&"
	;;
"macos")
	C_CPP_NAME="macOS"
	# 对于 macOS, 通常是 clang
	COMPILER_PATH="/usr/bin/clang"
	INTELLISENSE_MODE="macos-clang-x64"
	# 使用 lldb
	DEBUGGER_MI_MODE="lldb"
	EXECUTABLE_SUFFIX=""
	# macOS shell 使用 && 连接命令
	COMMAND_SEPARATOR="&&"
	;;
"windows")
	C_CPP_NAME="Win32"
	# --------------------------------------------------------------------------
	# !! 重要 !!: Windows 用户请根据你的环境修改此路径！
	# --------------------------------------------------------------------------
	COMPILER_PATH="C:/msys64/mingw64/bin/g++.exe"
	INTELLISENSE_MODE="windows-gcc-x64"
	# MinGW 使用 gdb
	DEBUGGER_MI_MODE="gdb"
	EXECUTABLE_SUFFIX=".exe"
	# cmd 和 PowerShell 都支持 &&
	COMMAND_SEPARATOR="&&"
	;;
*)
	echo "错误: 不支持的平台 '$PLATFORM'。"
	echo "请使用 'linux', 'macos', 或 'windows'。"
	exit 1
	;;
esac

VSCODE_DIR="."

# ==============================================================================
# 1. 生成 c_cpp_properties.json
# ==============================================================================
cat >"${VSCODE_DIR}/c_cpp_properties.json" <<EOF
{
    "configurations": [
        {
            "name": "${C_CPP_NAME}",
            "includePath": [
                "\${workspaceFolder}/**"
            ],
            "defines": [],
            "compilerPath": "${COMPILER_PATH}",
            "cStandard": "c17",
            "cppStandard": "c++17",
            "intelliSenseMode": "${INTELLISENSE_MODE}",
            "compileCommands": "\${workspaceFolder}/build/compile_commands.json"
        }
    ],
    "version": 4
}
EOF
echo "c_cpp_properties.json"

# ==============================================================================
# 2. 生成 launch.json
# ==============================================================================
cat >"${VSCODE_DIR}/launch.json" <<EOF
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(${DEBUGGER_MI_MODE}) Launch",
            "type": "cppdbg",
            "request": "launch",
            "program": "\${workspaceFolder}/build/${EXECUTABLE_NAME}${EXECUTABLE_SUFFIX}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "\${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "${DEBUGGER_MI_MODE}",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for ${DEBUGGER_MI_MODE}",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ]
        }
    ]
}
EOF
echo "launch.json"

# ==============================================================================
# 3. 生成 tasks.json
# ==============================================================================
cat >"${VSCODE_DIR}/tasks.json" <<EOF
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "CMake Configure",
            "type": "shell",
            // 1. 通过快捷键 Ctrl+Shift+P -> Tasks: Run Task 运行该任务 -> CMake Configure
            "command": "cmake",
            "args": [
                "-S",
                "\${workspaceFolder}",
                "-B",
                "\${workspaceFolder}/build",
                // 生成 compile_commands.json 
                "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
            ],
            "group": "build",
            "presentation": {
                "clear": true
            },
            "problemMatcher": []
        },
        {
            "label": "CMake Build",
            "type": "shell",
            // 2. 通过快捷键 Ctrl+Shift+P -> Tasks: Run Task 运行该任务 -> CMake Build
            "command": "cmake --build \${workspaceFolder}/build",
            "group": {
                "kind": "build"
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": true,
                "panel": "new",
                "clear": true
            },
            "problemMatcher": "\$gcc"
        },
        {
            "label": "Build And Run",
            "type": "shell",
            // 3. 通过快捷键 Ctrl+Shift+P -> Tasks: Run Task 运行该任务 -> Build And Run
            "command": "cmake --build \${workspaceFolder}/build ${COMMAND_SEPARATOR} \${workspaceFolder}/build/${EXECUTABLE_NAME}${EXECUTABLE_SUFFIX}",
            "group": {
                "kind": "build",
                // 将 "CMake Build" 任务设置为默认构建任务，可以通过快捷键 Ctrl+Shift+B 直接运行。
                "isDefault": true
            },
            "presentation": {
                "echo": true,
                "reveal": "always",
                "focus": true,
                "panel": "new",
                "clear": true
            },
            "problemMatcher": "\$gcc"
        }
    ]
}
EOF
echo "tasks.json"

if [ "$PLATFORM" = "windows" ]; then
	echo "请注意: Windows 的编译器路径设置为 '${COMPILER_PATH}'。"
	echo "如果路径不正确，请在脚本中手动修改它。"
fi

exit 0
