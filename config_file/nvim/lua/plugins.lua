---@diagnostic disable: undefined-global

local function flag_enabled(name)
    local value = vim.g[name]
    return value == nil or value == 1
end

return {
    -- 基础工具
    --{"Shougo/unite.vim"},

    -- Git
    {"lewis6991/gitsigns.nvim", opts = {signs_staged_enable = false}},
    {"tpope/vim-fugitive"},
    -- 基础增强
    {
        "chentoast/marks.nvim",
        config = true
        --config = function()
        --require("marks").setup({})
        --end
    },
    {"deris/vim-shot-f"},
    -- LSP / 补全 / 格式化
    {"neoclide/coc.nvim", branch = "release", cond = flag_enabled("is_coc_vim")},
    {
        "SirVer/ultisnips",
        dependencies = {"keelii/vim-snippets"},
        init = function()
            vim.g.UltiSnipsExpandTrigger = "<tab>"
            vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
            vim.g.UltiSnipsJumpBackwardTrigger = "<S-tab>"
        end
    },
    -- 主题
    {"junegunn/seoul256.vim", priority = 1000},
    {"shaunsingh/nord.nvim"},
    {"Mofiqul/vscode.nvim"},
    {"nyoom-engineering/oxocarbon.nvim"},
    {"sheerun/vim-polyglot"}, -- 这个插件可能过于庞大，我只是为了使用它的缩进样式
    -- Gdiff
    {"vim-autoformat/vim-autoformat"},
    {"majutsushi/tagbar"},
    -- LaTeX
    {"lervag/vimtex", tag = "v2.15", cond = flag_enabled("is_latex")},
    {"KeitaNakamura/tex-conceal.vim", ft = {"tex", "plaintex"}, cond = flag_enabled("is_latex")},
    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        ft = {"markdown"},
        cond = flag_enabled("is_markdown"),
        build = "cd app && ./install.sh"
    },
    -- 文件/注释/通知等
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim"
        }
    },
    {"preservim/nerdcommenter"},
    {
        "rcarriga/nvim-notify",
        version = "v3.13.5",
        cond = function()
            return vim.fn.has("nvim") == 1 and flag_enabled("is_nvim_notify")
        end,
        config = function()
            vim.notify = require("notify")
        end
    },
    -- FZF
    {
        "junegunn/fzf",
        build = "./install --all"
    },
    {
        "junegunn/fzf.vim",
        dependencies = {"junegunn/fzf"}
    },
    -- 自动保存
    {"907th/vim-auto-save"},
    -- copilot
    --{ "github/copilot.vim" },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        -- 兼容nvim 0.9.3版本 (第一次克隆插件时，它通常会先拉取仓库，然后再执行 checkout 到指定 commit 的操作，所以需要手动执行一下lazy的U)
        commit = "cfc6f2c",
        build = ":TSUpdate"
    },
    {
        "yetone/avante.nvim",
        cond = function()
            return vim.fn.has("nvim-0.10") == 1
        end,
        build = "make",
        event = "VeryLazy",
        version = false,
        opts = {
            provider = "gemini",
            providers = {
                gemini = {
                    --endpoint = "https://api.anthropic.com",
                    model = "gemini-3-flash-preview",
                    --model = "gemini-2.5-flash",
                    --model = "gemini-2.5-pro",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {temperature = 0.75, max_tokens = 20480}
                }
            }
        },
        dependencies = {"nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"}
    }
}
