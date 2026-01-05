local function flag_enabled(name)
    local value = vim.g[name]
    return value == nil or value == 1
end

return {
    -- 基础工具
    --{"dense-analysis/ale"},
    {"Shougo/unite.vim"},
    --{"Shougo/neomru.vim"},
    --{"Shougo/deoplete.nvim", { 'do': ':UpdateRemotePlugins' } },
    --{"Shougo/ddc.vim"},
    {"airblade/vim-gitgutter"},
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup({})
        end
    },
    {"tpope/vim-fugitive"},
    {"sheerun/vim-polyglot"},
    {"vim-autoformat/vim-autoformat"},
    {
        "neoclide/coc.nvim",
        branch = "release",
        cond = flag_enabled("is_coc_vim")
    },
    {"majutsushi/tagbar"},
    --{"bronson/vim-trailing-whitespace"},
    -- 主题
    {"junegunn/seoul256.vim", priority = 1000},
    {"shaunsingh/nord.nvim"},
    --{"doums/darcula"},
    {"Mofiqul/vscode.nvim"},
    --{"dylanaraps/wal"},
    --{"morhetz/gruvbox"},
    {"nyoom-engineering/oxocarbon.nvim"},
    -- 代码片段
    {
        "SirVer/ultisnips",
        dependencies = {"keelii/vim-snippets"},
        init = function()
            vim.g.UltiSnipsExpandTrigger = "<tab>"
            vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
            vim.g.UltiSnipsJumpBackwardTrigger = "<S-tab>"
        end
    },
    -- LaTeX
    {
        "lervag/vimtex",
        cond = flag_enabled("is_latex")
    },
    {
        "KeitaNakamura/tex-conceal.vim",
        ft = {"tex", "plaintex"},
        cond = flag_enabled("is_latex")
    },
    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        ft = {"markdown", "vim-plug"},
        cond = flag_enabled("is_markdown"),
        build = function()
            vim.fn["mkdp#util#install"]()
        end
    },
    -- 文件/注释/通知等
    {"scrooloose/nerdtree"},
    {"preservim/nerdcommenter"},
    {
        "rcarriga/nvim-notify",
        cond = function()
            return vim.fn.has("nvim") == 1 and flag_enabled("is_nvim_notify")
        end,
        config = function()
            vim.notify = require("notify")
        end
    },
    {"deris/vim-shot-f"},
    -- FZF
    {
        "junegunn/fzf",
        build = function()
            vim.fn["fzf#install"]()
        end
    },
    {
        "junegunn/fzf.vim",
        dependencies = {"junegunn/fzf"}
    },
    --{"BurntSushi/ripgrep"},
    --{"rking/ag.vim"},
    --{"nvim-tree/nvim-tree.lua"},
    --{"nvim-tree/nvim-web-devicons"},
    --{"nvim-tree/nvim-web-devicons"},
    --{"lewis6991/gitsigns.nvim"},
    --{"romgrk/barbar.nvim"},
    --{"nvim-tree/nvim-web-devicons"},
    --{"ryanoasis/vim-devicons' Icons without colours},
    --{"akinsho/bufferline.nvim", { 'tag': '*' }},
    -- 自动保存
    {"907th/vim-auto-save"},
    -- copilot
    --{ "github/copilot.vim" },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate"
    },
    {
        "yetone/avante.nvim",
        build = "make",
        event = "VeryLazy",
        version = false, -- 永远不要将此值设置为 "*"！永远不要！
        opts = {
            provider = "gemini",
            providers = {
                gemini = {
                    --endpoint = "https://api.anthropic.com",
                    model = "gemini-2.5-flash",
                    --model = "gemini-2.5-pro",
                    timeout = 30000, -- Timeout in milliseconds
                    extra_request_body = {
                        temperature = 0.75,
                        max_tokens = 20480
                    }
                }
            }
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim"
        }
    },
    {"compnerd/arm64asm-vim"}
}
