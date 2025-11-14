local function flag_enabled(name)
    local value = vim.g[name]
    return value == nil or value == 1
end

return {
    -- 基础工具
    --{"dense-analysis/ale", lazy = false},
    {"Shougo/unite.vim", lazy = false},
    --{"Shougo/neomru.vim", lazy = false},
    --{"Shougo/deoplete.nvim", { 'do': ':UpdateRemotePlugins' } , lazy = false},
    --{"Shougo/ddc.vim", lazy = false},
    {"airblade/vim-gitgutter", lazy = false},
    {
        "chentoast/marks.nvim",
        lazy = false,
        config = function()
            require("marks").setup({})
        end
    },
    {"tpope/vim-fugitive", lazy = false},
    {"sheerun/vim-polyglot", lazy = false},
    {"vim-autoformat/vim-autoformat", lazy = false},
    {
        "neoclide/coc.nvim",
        branch = "release",
        lazy = false,
        cond = flag_enabled("is_coc_vim")
    },
    {"majutsushi/tagbar", lazy = false},
    --{"bronson/vim-trailing-whitespace", lazy = false},
    -- 主题
    {"junegunn/seoul256.vim", lazy = false, priority = 1000},
    {"shaunsingh/nord.nvim", lazy = false},
    --{"doums/darcula", lazy = false},
    {"Mofiqul/vscode.nvim", lazy = false},
    --{"dylanaraps/wal", lazy = false},
    --{"morhetz/gruvbox", lazy = false},
    {"nyoom-engineering/oxocarbon.nvim", lazy = false},
    -- 代码片段
    {"SirVer/ultisnips", lazy = false},
    {"keelii/vim-snippets", lazy = false},
    -- LaTeX
    {
        "lervag/vimtex",
        tag = "v2.14",
        lazy = false,
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
    {"scrooloose/nerdtree", lazy = false},
    {"preservim/nerdcommenter", lazy = false},
    {
        "rcarriga/nvim-notify",
        cond = function()
            return vim.fn.has("nvim") == 1 and flag_enabled("is_nvim_notify")
        end,
        config = function()
            vim.notify = require("notify")
        end
    },
    {"deris/vim-shot-f", lazy = false},
    -- FZF
    {
        "junegunn/fzf",
        lazy = false,
        build = function()
            vim.fn["fzf#install"]()
        end
    },
    {
        "junegunn/fzf.vim",
        lazy = false,
        dependencies = {"junegunn/fzf"}
    },
    --{"BurntSushi/ripgrep", lazy = false},
    --{"rking/ag.vim", lazy = false},
    --{"nvim-tree/nvim-tree.lua", lazy = false},
    --{"nvim-tree/nvim-web-devicons", lazy = false},
    --{"nvim-tree/nvim-web-devicons", lazy = false},
    --{"lewis6991/gitsigns.nvim", lazy = false},
    --{"romgrk/barbar.nvim", lazy = false},
    --{"nvim-tree/nvim-web-devicons", lazy = false},
    --{"ryanoasis/vim-devicons' Icons without colours, lazy = false},
    --{"akinsho/bufferline.nvim", { 'tag': '*' }, lazy = false},
    -- 自动保存
    {"907th/vim-auto-save", lazy = false},
    -- copilot
    --{ "github/copilot.vim", lazy = false },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
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
            "MunifTanjim/nui.nvim",
            --- option
            "echasnovski/mini.pick", -- 用于文件选择器提供者 mini.pick
            --"nvim-telescope/telescope.nvim", -- 用于文件选择器提供者 telescope
            "hrsh7th/nvim-cmp", -- avante 命令和提及的自动完成
            --"ibhagwan/fzf-lua", -- 用于文件选择器提供者 fzf
            "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
            --"zbirenbaum/copilot.lua", -- 用于 providers='copilot'
            {
                -- 支持图像粘贴
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {insert_mode = true},
                        use_absolute_path = true
                    }
                }
            },
            {
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {file_types = {"markdown", "Avante"}},
                ft = {"markdown", "Avante"}
            }
        }
    }
}
