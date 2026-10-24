#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook True

; 开启 Per-Monitor V2 DPI 感知，确保多显示器不同缩放比例下坐标准确
DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")

; 记录窗口分屏前的原始位置和大小，以及最近一次分屏状态
global OriginalBounds := Map()
global LastSnapState  := Map()

; ==============================================================================
; macOS Magnet 风格快捷键
; 同时绑定 <!# (PowerToys 映射后的 Left Alt + Win) 与 <^# (物理 Left Ctrl + Win)
; 这样无论 PowerToys 与 AutoHotkey 谁先启动，钩子都能 100% 拦截，
; 且能阻止 Windows 11 原生 Win+Alt+K 弹出 "No supported app / no support" 麦克风提示
; ==============================================================================

; --- 二分之一屏 (1/2) ---
<!#Left::
<^#Left::  SnapActiveWindow("Left")

<!#Right::
<^#Right:: SnapActiveWindow("Right")

<!#Up::
<^#Up::    SnapActiveWindow("Up")

<!#Down::
<^#Down::  SnapActiveWindow("Down")

; --- 四分之一屏 (1/4) ---
<!#u::
<^#u::     SnapActiveWindow("TopLeft")

<!#i::
<^#i::     SnapActiveWindow("TopRight")

<!#j::
<^#j::     SnapActiveWindow("BottomLeft")

<!#k::
<^#k::     SnapActiveWindow("BottomRight")

; --- 智能居中 (Center) ---
<!#c::
<^#c::     SnapActiveWindow("Center")

; --- 最大化与还原 ---
<!#Enter::
<^#Enter::     SnapActiveWindow("Maximize")

<!#Backspace::
<^#Backspace:: SnapActiveWindow("Restore")

; ==============================================================================
; 核心窗口布局逻辑
; ==============================================================================
SnapActiveWindow(mode) {
    global OriginalBounds, LastSnapState

    hwnd := WinExist("A")
    if !hwnd
        return

    ; 忽略桌面和任务栏等系统窗口
    try {
        winClass := WinGetClass(hwnd)
    } catch {
        return
    }
    if (winClass = "Progman" || winClass = "WorkerW" || winClass = "Shell_TrayWnd" || winClass = "Shell_SecondaryTrayWnd")
        return

    ; 获取当前窗口状态与位置
    try {
        minMax := WinGetMinMax(hwnd)
        WinGetPos(&curX, &curY, &curW, &curH, hwnd)
    } catch {
        return
    }

    ; 如果窗口处于普通状态，且未被记录或用户已手动拖动/缩放过，则更新其「原始尺寸与位置」
    if (minMax = 0) {
        if !OriginalBounds.Has(hwnd) || !IsSamePos(hwnd, curX, curY, curW, curH) {
            OriginalBounds[hwnd] := {x: curX, y: curY, w: curW, h: curH}
        }
    }

    ; 处理「最大化」
    if (mode = "Maximize") {
        try WinMaximize(hwnd)
        LastSnapState[hwnd] := {mode: "Maximize", x: curX, y: curY, w: curW, h: curH}
        return
    }

    ; 处理「还原 (Backspace)」
    if (mode = "Restore") {
        if (minMax != 0)
            try WinRestore(hwnd)
        if OriginalBounds.Has(hwnd) {
            orig := OriginalBounds[hwnd]
            MoveWindowCompensated(hwnd, orig.x, orig.y, orig.w, orig.h, false)
            LastSnapState[hwnd] := {mode: "Restore", x: orig.x, y: orig.y, w: orig.w, h: orig.h}
        }
        return
    }

    ; 获取当前窗口所在显示器的可用工作区 (Work Area，排除任务栏)
    work := GetMonitorWorkAreaFromWindow(hwnd)
    monX := work.left
    monY := work.top
    monW := work.right - work.left
    monH := work.bottom - work.top

    halfW := monW // 2
    halfH := monH // 2

    targetX := monX
    targetY := monY
    targetW := monW
    targetH := monH
    actualMode := mode

    switch mode {
        case "Left":
            targetX := monX, targetY := monY, targetW := halfW, targetH := monH
        case "Right":
            targetX := monX + halfW, targetY := monY, targetW := monW - halfW, targetH := monH
        case "Up":
            targetX := monX, targetY := monY, targetW := monW, targetH := halfH
        case "Down":
            targetX := monX, targetY := monY + halfH, targetW := monW, targetH := monH - halfH
        case "TopLeft":
            targetX := monX, targetY := monY, targetW := halfW, targetH := halfH
        case "TopRight":
            targetX := monX + halfW, targetY := monY, targetW := monW - halfW, targetH := halfH
        case "BottomLeft":
            targetX := monX, targetY := monY + halfH, targetW := halfW, targetH := monH - halfH
        case "BottomRight":
            targetX := monX + halfW, targetY := monY + halfH, targetW := monW - halfW, targetH := monH - halfH
        case "Center":
            prevMode := LastSnapState.Has(hwnd) ? LastSnapState[hwnd].mode : ""
            if (prevMode = "CenterRatio" && OriginalBounds.Has(hwnd)) {
                ; 第二次按 C：使用窗口原始尺寸居中
                orig := OriginalBounds[hwnd]
                targetW := Min(orig.w, monW)
                targetH := Min(orig.h, monH)
                actualMode := "CenterOrig"
            } else {
                ; 第一次按 C：黄金比例 (70% 宽 × 80% 高) 居中
                targetW := Round(monW * 0.70)
                targetH := Round(monH * 0.80)
                actualMode := "CenterRatio"
            }
            targetX := monX + (monW - targetW) // 2
            targetY := monY + (monH - targetH) // 2
    }

    ; 若窗口当前处于最大化状态，先还原再移动
    if (minMax != 0)
        try WinRestore(hwnd)

    ; 精确移动窗口并补偿 Windows DWM 透明阴影边框
    MoveWindowCompensated(hwnd, targetX, targetY, targetW, targetH, true)

    ; 记录移动后的实际窗口位置，用于后续判断用户是否手动移动过窗口
    try {
        WinGetPos(&finalX, &finalY, &finalW, &finalH, hwnd)
        LastSnapState[hwnd] := {mode: actualMode, x: finalX, y: finalY, w: finalW, h: finalH}
    }
}

; 判断窗口当前位置是否与上次脚本设置的位置一致
IsSamePos(hwnd, curX, curY, curW, curH) {
    global LastSnapState
    if !LastSnapState.Has(hwnd)
        return false
    st := LastSnapState[hwnd]
    return (Abs(curX - st.x) <= 10 && Abs(curY - st.y) <= 10 && Abs(curW - st.w) <= 10 && Abs(curH - st.h) <= 10)
}

; 获取窗口所在显示器的工作区坐标
GetMonitorWorkAreaFromWindow(hwnd) {
    ; MONITOR_DEFAULTTONEAREST = 2
    hMon := DllCall("user32\MonitorFromWindow", "ptr", hwnd, "uint", 2, "ptr")
    monInfo := Buffer(40, 0)
    NumPut("uint", 40, monInfo, 0)
    if DllCall("user32\GetMonitorInfoW", "ptr", hMon, "ptr", monInfo) {
        ; rcWork 位于偏移量 20 处 (left, top, right, bottom 各 4 字节)
        return {
            left:   NumGet(monInfo, 20, "int"),
            top:    NumGet(monInfo, 24, "int"),
            right:  NumGet(monInfo, 28, "int"),
            bottom: NumGet(monInfo, 32, "int")
        }
    }
    ; 兜底使用主显示器工作区
    MonitorGetWorkArea(, &wl, &wt, &wr, &wb)
    return {left: wl, top: wt, right: wr, bottom: wb}
}

; 移动窗口并自动修正 Windows 10/11 的隐形阴影边框 (DWM Extended Frame Bounds)
MoveWindowCompensated(hwnd, x, y, w, h, compensateDwm := true) {
    ; 先按目标坐标移动一次，让窗口进入目标显示器的 DPI 上下文
    DllCall("user32\SetWindowPos", "ptr", hwnd, "ptr", 0, "int", x, "int", y, "int", w, "int", h, "uint", 0x0014)

    if !compensateDwm
        return

    winRect   := Buffer(16, 0)
    frameRect := Buffer(16, 0)
    if DllCall("user32\GetWindowRect", "ptr", hwnd, "ptr", winRect)
    && (DllCall("dwmapi\DwmGetWindowAttribute", "ptr", hwnd, "uint", 9, "ptr", frameRect, "uint", 16) = 0) {
        winL := NumGet(winRect, 0, "int"),   winT := NumGet(winRect, 4, "int")
        winR := NumGet(winRect, 8, "int"),   winB := NumGet(winRect, 12, "int")
        frmL := NumGet(frameRect, 0, "int"), frmT := NumGet(frameRect, 4, "int")
        frmR := NumGet(frameRect, 8, "int"), frmB := NumGet(frameRect, 12, "int")

        offL := frmL - winL
        offT := frmT - winT
        offR := winR - frmR
        offB := winB - frmB

        if (offL != 0 || offT != 0 || offR != 0 || offB != 0) {
            adjX := x - offL
            adjY := y - offT
            adjW := w + offL + offR
            adjH := h + offT + offB
            DllCall("user32\SetWindowPos", "ptr", hwnd, "ptr", 0, "int", adjX, "int", adjY, "int", adjW, "int", adjH, "uint", 0x0014)
        }
    }
}
