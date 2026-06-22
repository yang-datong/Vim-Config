-- 播放结束后按空格从头开始播放，否则正常切换暂停/播放
local mp = require 'mp'

mp.add_key_binding("SPACE", "space-restart", function()
    local eof = mp.get_property_bool("eof-reached")

    if eof then
        -- 视频已播放完毕：跳回开头并开始播放
        mp.commandv("seek", 0, "absolute")
        mp.set_property_bool("pause", false)
    else
        -- 正常切换 暂停/播放
        mp.commandv("cycle", "pause")
    end
end)
