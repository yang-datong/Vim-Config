## Windows修改为Mac OS习惯

> https://zhuanlan.zhihu.com/p/496803742

1. 修改PowerToys的键盘配置文件（PowerToyes一定要以管理员身份运行，不然在某些应用中会扰乱键盘映射），如下：

```json
PS C:\Users\hi> cat 'C:\Users\hi\AppData\Local\Microsoft\PowerToys\Keyboard Manager\default.json'

{"remapKeys":{"inProcess":[{"originalKeys":"20","newRemapKeys":"163;32"},{"originalKeys":"164","newRemapKeys":"162"},{"originalKeys":"162","newRemapKeys":"164"}]},"remapKeysToText":{"inProcess":[]},"remapShortcuts":{"global":[{"originalKeys":"162;8","exactMatch":false,"newRemapKeys":"46"},{"originalKeys":"162;9","exactMatch":false,"operationType":0,"newRemapKeys":"164;9"},{"originalKeys":"162;32","exactMatch":false,"operationType":0,"newRemapKeys":"164;32"},{"originalKeys":"162;72","exactMatch":false,"operationType":0,"newRemapKeys":"91;40"},{"originalKeys":"91;37","exactMatch":false,"operationType":0,"newRemapKeys":"163;37"},{"originalKeys":"91;39","exactMatch":false,"operationType":0,"newRemapKeys":"163;39"}],"appSpecific":[]},"remapShortcutsToText":{"global":[],"appSpecific":[]}}
```

> 备份文件位于：`./config/powertoys-keyboard-default.json` 与 `./config/powertoys-keyboard-editorSettings.json`
> 注意：如果按物理 `Win` 键无反应，先检查是否误触了机械键盘硬件锁 `Fn + Win`。

此时已经完成大部分配置，注意，还需要重新进入到PowerToys设置中，键盘管理器点击一次保存让配置文件得到应用。

2. 修改一些重复冲突键：右键输入法，进入到`Time & language` -> `Language & region` -> `Microsoft PinYin` -> `Keys`的Chinese/English mode switch，取消勾选Shift，这一步是为了防止`Caps`键与`Shift`键同时能够切换输入法。
3. 输入默认为英文输入（防止每次打开一个新软件就切换为中文输入）：右键输入法，进入到`Time & language` -> `Language & region` -> `Microsoft PinYin` -> `General` -> `Chooose IME default mode` 选择English

4. 类 macOS Magnet 窗口布局快捷键（基于 AutoHotkey v2）：
   - 脚本备份路径：`./config/MagnetWindow.ahk`
   - 运行路径：`$HOME\Documents\AutoHotkey\MagnetWindow.ahk`
   - 开机自启路径：`$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Startup\MagnetWindow.lnk`
   - 快捷键（物理按键：`左Ctrl + Win` + 对应键）：
     - **二分之一屏 (1/2)**：`←`（左半屏）、`→`（右半屏）、`↑`（上半屏）、`↓`（下半屏）
     - **四分之一屏 (1/4)**：`U`（左上）、`I`（右上）、`J`（左下）、`K`（右下）
     - **智能居中 (Center)**：`C`（第 1 次按：70%宽×80%高黄金比例居中；连续第 2 次按：保持窗口原尺寸居中）
     - **最大化 / 还原**：`Enter`（最大化）、`Backspace`（还原到分屏前尺寸与位置）
