## Windows修改为Mac OS习惯

> https://zhuanlan.zhihu.com/p/496803742

1. 修改PowerToys的键盘配置文件（PowerToyes一定要以管理员身份运行，不然在某些应用中会扰乱键盘映射），如下：

```json
PS C:\Users\hi> cat 'C:\Users\hi\AppData\Local\Microsoft\PowerToys\Keyboard Manager\default.json'

{"remapKeys":{"inProcess":[{"originalKeys":"20","newRemapKeys":"163;32"},{"originalKeys":"164","newRemapKeys":"162"},{"originalKeys":"162","newRemapKeys":"164"}]},"remapKeysToText":{"inProcess":[]},"remapShortcuts":{"global":[{"originalKeys":"162;8","exactMatch":false,"newRemapKeys":"46"},{"originalKeys":"162;9","exactMatch":false,"operationType":0,"newRemapKeys":"164;9"},{"originalKeys":"162;32","exactMatch":false,"operationType":0,"newRemapKeys":"164;32"},{"originalKeys":"162;72","exactMatch":false,"operationType":0,"newRemapKeys":"91;40"},{"originalKeys":"91;37","exactMatch":false,"operationType":0,"newRemapKeys":"163;37"},{"originalKeys":"91;39","exactMatch":false,"operationType":0,"newRemapKeys":"163;39"},{"originalKeys":"91;164;8","exactMatch":false,"operationType":0,"newRemapKeys":"91;38"},{"originalKeys":"91;164;13","exactMatch":false,"operationType":0,"newRemapKeys":"91;38"},{"originalKeys":"91;164;37","exactMatch":false,"operationType":0,"newRemapKeys":"91;37"},{"originalKeys":"91;164;39","exactMatch":false,"operationType":0,"newRemapKeys":"91;39"}],"appSpecific":[]},"remapShortcutsToText":{"global":[],"appSpecific":[]}}
```

此时已经完成大部分配置，注意，还需要重新进入到PowerToys设置中，键盘管理器点击一次保存让配置文件得到应用。

2. 修改一些重复冲突键：右键输入法，进入到`Time & language` -> `Language & region` -> `Microsoft PinYin` -> `Keys`的Chinese/English mode switch，取消勾选Shift，这一步是为了防止`Caps`键与`Shift`键同时能够切换输入法。
3. 输入默认为英文输入（防止每次打开一个新软件就切换为中文输入）：右键输入法，进入到`Time & language` -> `Language & region` -> `Microsoft PinYin` -> `General` -> `Chooose IME default mode` 选择English
