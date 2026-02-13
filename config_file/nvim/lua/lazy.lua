---@diagnostic disable: undefined-global

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system(
        {
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath
        }
    )
end
vim.opt.rtp:prepend(lazypath)

-- "plugins" 对应 $NVIMHOME/lua/plugins.lua 文件
require("lazy").setup(
    "plugins",
    {
        -- 禁用 luarocks 支持，解决 checkhealth 报错
        rocks = {
            enabled = false
        }
    }
)
