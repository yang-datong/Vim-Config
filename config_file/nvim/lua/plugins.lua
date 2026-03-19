---@diagnostic disable: undefined-global

local function flag_enabled(name)
    local value = vim.g[name]
    return value == nil or value == 1
end

local function is_mac()
    return vim.fn.has("mac") == 1
end

local function is_linux()
    return vim.fn.has("linux") == 1
end

local function nerdcommenter_toggle_normal()
    vim.fn["nerdcommenter#Comment"]("n", "toggle")
    vim.cmd("normal 0j")
end

local function nerdcommenter_toggle_visual(move_cursor)
    vim.fn["nerdcommenter#Comment"]("x", "invert")
    if move_cursor then
        vim.cmd("normal 0j")
    end
end

return {
    -- 基础工具
    --{"Shougo/unite.vim"},

    -- Git
    {"lewis6991/gitsigns.nvim", opts = {signs_staged_enable = false}},
    {
        "tpope/vim-fugitive",
        keys = {
            {"<leader>gs", "<cmd>Git<CR>", mode = "n", silent = true},
            {"<leader>gd", "<cmd>Gvdiff<CR>", mode = "n", silent = true}
        }
    },
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
    {
        "neoclide/coc.nvim",
        branch = "release",
        cond = flag_enabled("is_coc_vim"),
        init = function()
            vim.g.coc_global_extensions = {
                "coc-clangd",
                "coc-snippets",
                "coc-texlab",
                "coc-sh",
                "coc-cmake",
                "coc-json",
                "coc-pyright",
                "coc-powershell",
                "coc-lua",
                "coc-yaml"
            }

            if vim.g.is_latex == 1 then
                local grp = vim.api.nvim_create_augroup("CocLatexBootstrap", {clear = true})
                vim.api.nvim_create_autocmd("User", {
                    group = grp,
                    pattern = "CocJumpPlaceholderPre",
                    callback = function()
                        if vim.fn.exists("*coc#rpc#ready") == 1 and vim.fn["coc#rpc#ready"]() == 0 then
                            vim.cmd("silent! CocStart --channel-ignored")
                        end
                    end
                })

                if is_mac() and vim.fn.executable("texlab") == 0 then
                    vim.schedule(function()
                        vim.notify("Please use -> brew install --HEAD texlab", vim.log.levels.WARN)
                    end)
                end
            end
        end
    },
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
    {
        "vim-autoformat/vim-autoformat",
        init = function()
            if vim.g.is_latex == 1 then
                vim.g.formatdef_latexindent = '"latexindent -"'
            end
            vim.g.formatdef_nasmfmt = '"asmfmt"'
            vim.g.formatters_nasm = {"nasmfmt"}
        end
    },
    {
        "majutsushi/tagbar",
        cmd = {"TagbarOpen", "TagbarToggle"},
        keys = {
            {"<F2>", "<cmd>TagbarToggle<CR>", mode = "n", silent = true}
        },
        init = function()
            vim.g.tagbar_sort = 0
            if vim.g.is_vim_studio == 1 then
                local grp = vim.api.nvim_create_augroup("TagbarStudioAutoOpen", {clear = true})
                vim.api.nvim_create_autocmd("VimEnter", {
                    group = grp,
                    callback = function()
                        vim.cmd("TagbarOpen")
                    end
                })
            end
        end
    },
    -- LaTeX
    {
        "lervag/vimtex",
        tag = "v2.15",
        cond = flag_enabled("is_latex"),
        init = function()
            vim.g.vimtex_quickfix_mode = 0
            vim.g.tex_flavor = "latex"

            if is_mac() then
                vim.g.vimtex_view_general_viewer = "skim"
                vim.g.vimtex_view_method = "skim"
            elseif is_linux() then
                vim.g.vimtex_view_general_viewer = "zathura"
                vim.g.vimtex_view_method = "zathura"
            end

            vim.g.vimtex_view_skim_sync = 0
            vim.g.vimtex_view_skim_activate = 0
            vim.g.vimtex_compiler_progname = "nvr"

            local macro_definition = ""
            if vim.g.latex_full_compiled_mode == 0 then
                if is_mac() then
                    macro_definition = "\\def\\Mac{true}"
                end
            else
                macro_definition = ""
                    .. "\\def\\StandardModel{true}"
                    .. "\\def\\ShowAfterClassExercises{true}"
                    .. "\\def\\UseInkscapeTools{true}"
            end

            vim.g.vimtex_compiler_latexmk = {
                executable = "latexmk",
                options = {
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=batchmode",
                    "-pretex=" .. vim.fn.shellescape(macro_definition),
                    "-usepretex",
                    "-output-directory=build"
                },
                out_dir = "build"
            }

            vim.g.tex_conceal_frac = 1
            vim.g.tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
            vim.g.tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
            vim.g.tex_conceal = "abdmg"
            vim.opt.conceallevel = 2
            vim.cmd("hi Conceal ctermbg=none")

            local grp = vim.api.nvim_create_augroup("VimtexPreviewMap", {clear = true})
            vim.api.nvim_create_autocmd("FileType", {
                group = grp,
                pattern = {"tex", "plaintex"},
                callback = function(ev)
                    vim.keymap.set("n", "\\v", "\\lv", {buffer = ev.buf})
                    vim.keymap.set("n", "'v", "\\lv", {buffer = ev.buf})
                end
            })
        end
    },
    {"KeitaNakamura/tex-conceal.vim", ft = {"tex", "plaintex"}, cond = flag_enabled("is_latex")},
    -- Markdown
    {
        "iamcco/markdown-preview.nvim",
        ft = {"markdown"},
        cond = flag_enabled("is_markdown"),
        build = "cd app && ./install.sh",
        init = function()
            if is_mac() then
                vim.g.mkdp_browser = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
            else
                vim.g.mkdp_browser = "/usr/bin/google-chrome-stable"
            end
        end
    },
    -- 文件/注释/通知等
    {
        "nvim-neo-tree/neo-tree.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim"
        },
        init = function()
            if vim.g.is_vim_studio == 1 then
                local grp = vim.api.nvim_create_augroup("NeoTreeStudioAutoOpen", {clear = true})
                vim.api.nvim_create_autocmd("VimEnter", {
                    group = grp,
                    callback = function()
                        vim.cmd("Neotree source=filesystem reveal=true show")
                    end
                })
            end
        end,
        cmd = {"Neotree"},
        keys = {
            {"<leader>F", "<cmd>Neotree focus<CR>", mode = "n", silent = true},
            {"<F1>", "<cmd>Neotree toggle<CR>", mode = "n", silent = true}
        }
    },
    {
        "preservim/nerdcommenter",
        init = function()
            vim.g.NERDCustomDelimiters = {
                c = {left = "/* ", right = " */"},
                asm = {left = "// "}
            }
        end,
        keys = function()
            local keys = {
                {
                    "<leader>/",
                    function()
                        nerdcommenter_toggle_normal()
                    end,
                    mode = "n",
                    silent = true
                },
                {
                    "<leader>/",
                    function()
                        nerdcommenter_toggle_visual(false)
                    end,
                    mode = "x",
                    silent = true
                }
            }

            if is_linux() then
                table.insert(keys, {
                    "<C-_>",
                    function()
                        nerdcommenter_toggle_normal()
                    end,
                    mode = "n",
                    silent = true
                })
                table.insert(keys, {
                    "<C-_>",
                    function()
                        nerdcommenter_toggle_visual(true)
                    end,
                    mode = "x",
                    silent = true
                })
            end

            return keys
        end
    },
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
    {
        "907th/vim-auto-save",
        init = function()
            local grp = vim.api.nvim_create_augroup("AutoSaveTexOnly", {clear = true})
            vim.api.nvim_create_autocmd("FileType", {
                group = grp,
                pattern = {"tex", "plaintex"},
                callback = function()
                    vim.b.auto_save = 1
                end
            })
        end
    },
    -- copilot
    --{ "github/copilot.vim" },
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        -- 兼容nvim 0.9.3版本 (第一次克隆插件时，它通常会先拉取仓库，然后再执行 checkout 到指定 commit 的操作，所以需要手动执行一下lazy的U)
        commit = "cfc6f2c",
        build = ":TSUpdate"
    },
    -- {
    --     "yetone/avante.nvim",
    --     cond = function()
    --         return vim.fn.has("nvim-0.10") == 1
    --     end,
    --     build = "make",
    --     event = "VeryLazy",
    --     version = false,
    --     opts = {
    --         provider = "gemini",
    --         providers = {
    --             gemini = {
    --                 --endpoint = "https://api.anthropic.com",
    --                 model = "gemini-3-flash-preview",
    --                 --model = "gemini-2.5-flash",
    --                 --model = "gemini-2.5-pro",
    --                 timeout = 30000, -- Timeout in milliseconds
    --                 extra_request_body = {temperature = 0.75, max_tokens = 20480}
    --             }
    --         }
    --     },
    --     dependencies = {"nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"}
    -- }
}
