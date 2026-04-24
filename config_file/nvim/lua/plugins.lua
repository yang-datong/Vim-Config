---@diagnostic disable: undefined-global

local api = vim.api
local fn = vim.fn
local g = vim.g

local HAS_MAC = fn.has("mac") == 1
local HAS_LINUX = fn.has("linux") == 1

local function flag_enabled(name)
	local value = g[name]
	return value == nil or value == 1
end

local function create_augroup(name)
	return api.nvim_create_augroup(name, { clear = true })
end

local function nerdcommenter_toggle_normal()
	fn["nerdcommenter#Comment"]("n", "toggle")
	vim.cmd("normal 0j")
end

local function nerdcommenter_toggle_visual(move_cursor)
	fn["nerdcommenter#Comment"]("x", "invert")
	if move_cursor then
		vim.cmd("normal 0j")
	end
end

local function nerdcommenter_toggle_visual_keep()
	nerdcommenter_toggle_visual(false)
end

local function nerdcommenter_toggle_visual_move()
	nerdcommenter_toggle_visual(true)
end

local function autocmd_vimenter(group_name, cb)
	api.nvim_create_autocmd("VimEnter", {
		group = create_augroup(group_name),
		callback = cb,
	})
end

return {
	-- Git
	{ "lewis6991/gitsigns.nvim", opts = { signs_staged_enable = false } },
	{
		"tpope/vim-fugitive",
		keys = {
			{ "<leader>gs", "<cmd>Git<CR>", mode = "n", silent = true },
			{ "<leader>gd", "<cmd>Gvdiff<CR>", mode = "n", silent = true },
		},
	},
	-- 基础增强
	{
		"chentoast/marks.nvim",
		config = true,
	},
	{ "deris/vim-shot-f" },
	-- LSP / 补全 / 格式化
	{
		"neoclide/coc.nvim",
		branch = "release",
		cond = flag_enabled("is_coc_vim"),
		init = function()
			g.coc_global_extensions = {
				"coc-clangd",
				"coc-snippets",
				"coc-texlab",
				"coc-sh",
				"coc-cmake",
				"coc-json",
				"coc-pyright",
				"coc-lua",
				"coc-yaml",
				--"coc-powershell",
			}

			if g.is_latex == 1 then
				api.nvim_create_autocmd("User", {
					group = create_augroup("CocLatexBootstrap"),
					pattern = "CocJumpPlaceholderPre",
					callback = function()
						if fn.exists("*coc#rpc#ready") == 1 and fn["coc#rpc#ready"]() == 0 then
							vim.cmd("silent! CocStart --channel-ignored")
						end
					end,
				})

				if HAS_MAC and fn.executable("texlab") == 0 then
					vim.schedule(function()
						vim.notify("Please use -> brew install --HEAD texlab", vim.log.levels.WARN)
					end)
				end
			end
		end,
	},
	{
		"SirVer/ultisnips",
		dependencies = { "keelii/vim-snippets" },
		init = function()
			g.UltiSnipsExpandTrigger = "<tab>"
			g.UltiSnipsJumpForwardTrigger = "<tab>"
			g.UltiSnipsJumpBackwardTrigger = "<S-tab>"
		end,
	},
	-- 主题
	{ "junegunn/seoul256.vim" },
	{ "shaunsingh/nord.nvim" },
	{ "Mofiqul/vscode.nvim" },
	{ "nyoom-engineering/oxocarbon.nvim" },
	{ "tpope/vim-sleuth" },
	-- Gdiff
	{
		"vim-autoformat/vim-autoformat",
		init = function()
			if g.is_latex == 1 then
				g.formatdef_latexindent = '"latexindent -"'
			end
			g.formatdef_nasmfmt = '"asmfmt"'
			g.formatters_nasm = { "nasmfmt" }
		end,
	},
	{
		"majutsushi/tagbar",
		cmd = { "TagbarOpen", "TagbarToggle" },
		keys = {
			{ "<F2>", "<cmd>TagbarToggle<CR>", mode = "n", silent = true },
		},
		init = function()
			g.tagbar_sort = 0
			if g.is_vim_studio == 1 then
				autocmd_vimenter("TagbarStudioAutoOpen", function()
					vim.cmd("TagbarOpen")
				end)
			end
		end,
	},
	-- LaTeX
	{
		"lervag/vimtex",
		--tag = "v2.15",
		cond = flag_enabled("is_latex"),
		init = function()
			g.vimtex_quickfix_mode = 0
			g.tex_flavor = "latex"

			local viewer = HAS_MAC and "skim" or (HAS_LINUX and "zathura" or nil)
			if viewer then
				g.vimtex_view_general_viewer = viewer
				g.vimtex_view_method = viewer
			end

			g.vimtex_view_skim_sync = 0
			g.vimtex_view_skim_activate = 0
			g.vimtex_compiler_progname = "nvr"

			local defs = {}
			if HAS_MAC then
				defs[#defs + 1] = "\\def\\Mac{true}"
			end
			if tonumber(g.latex_full_compiled_mode or 0) ~= 0 then
				defs[#defs + 1] = "\\def\\StandardModel{true}"
				defs[#defs + 1] = "\\def\\ShowAfterClassExercises{true}"
				defs[#defs + 1] = "\\def\\UseInkscapeTools{true}"
			end
			local macro_definition = table.concat(defs)

			g.vimtex_compiler_latexmk = {
				executable = "latexmk",
				options = {
					"-file-line-error",
					"-synctex=1",
					"-interaction=batchmode",
					"-pretex=" .. fn.shellescape(macro_definition),
					"-usepretex",
					"-output-directory=build",
				},
				out_dir = "build",
			}

			g.tex_conceal_frac = 1
			g.tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
			g.tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
			g.tex_conceal = "abdmg"
			vim.opt.conceallevel = 2
			vim.cmd("hi Conceal ctermbg=none")

			api.nvim_create_autocmd("User", {
				group = create_augroup("VimtexPreviewMap"),
				pattern = "VimtexEventInitPost",
				callback = function(ev)
					vim.keymap.set("n", "\\v", "<Plug>(vimtex-view)", { buffer = ev.buf, remap = true, silent = true })
					vim.keymap.set("n", "'v", "<Plug>(vimtex-view)", { buffer = ev.buf, remap = true, silent = true })
				end,
			})
		end,
	},
	{ "KeitaNakamura/tex-conceal.vim", ft = { "tex", "plaintex" }, cond = flag_enabled("is_latex") },
	-- Markdown
	{
		"iamcco/markdown-preview.nvim",
		ft = { "markdown" },
		cond = flag_enabled("is_markdown"),
		build = "cd app && ./install.sh",
		init = function()
			g.mkdp_browser = HAS_MAC and "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
				or "/usr/bin/google-chrome-stable"
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		dependencies = { "nvim-mini/mini.nvim", "nvim-mini/mini.icons", "nvim-tree/nvim-web-devicons" },
	},
	-- 文件/注释/通知等
	{
		"nvim-neo-tree/neo-tree.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
		},
		init = function()
			if g.is_vim_studio == 1 then
				autocmd_vimenter("NeoTreeStudioAutoOpen", function()
					vim.cmd("Neotree source=filesystem reveal=true show")
				end)
			end
		end,
		opts = {
			default_component_configs = {
				indent = {
					with_markers = true,
					indent_marker = "|",
					last_indent_marker = "`",
					with_expanders = true,
					expander_collapsed = ">",
					expander_expanded = "v",
				},
				icon = {
					folder_closed = "+",
					folder_open = "-",
					folder_empty = "~",
					folder_empty_open = "~",
					default = "*",
					provider = function(icon)
						return icon
					end,
				},
				git_status = {
					symbols = {
						added = "A",
						modified = "M",
						deleted = "D",
						renamed = "R",
						untracked = "U",
						ignored = "I",
						unstaged = "!",
						staged = "S",
						conflict = "X",
					},
				},
			},
		},
		cmd = { "Neotree" },
		keys = {
			{ "<leader>F", "<cmd>Neotree focus<CR>", mode = "n", silent = true },
			{ "<F1>", "<cmd>Neotree toggle<CR>", mode = "n", silent = true },
		},
	},
	{
		"preservim/nerdcommenter",
		lazy = false,
		init = function()
			g.NERDCustomDelimiters = {
				c = { left = "/* ", right = " */" },
				asm = { left = "// " },
			}
		end,
		keys = function()
			local keys = {
				{ "<leader>/", nerdcommenter_toggle_normal, mode = "n", silent = true },
				{ "<leader>/", nerdcommenter_toggle_visual_keep, mode = "x", silent = true },
			}

			if HAS_LINUX then
				table.insert(keys, { "<C-_>", nerdcommenter_toggle_normal, mode = "n", silent = true })
				table.insert(keys, { "<C-_>", nerdcommenter_toggle_visual_move, mode = "x", silent = true })
			end

			return keys
		end,
	},
	{
		"rcarriga/nvim-notify",
		--version = "v3.13.5",
		cond = flag_enabled("is_nvim_notify"),
		config = function()
			vim.notify = require("notify")
		end,
	},
	-- FZF
	--{
	--"junegunn/fzf",
	--build = "./install --all",
	--},
	--{
	--"junegunn/fzf.vim",
	--dependencies = { "junegunn/fzf" },
	--},
	-- 自动保存
	{
		"907th/vim-auto-save",
		init = function()
			api.nvim_create_autocmd("FileType", {
				group = create_augroup("AutoSaveTexOnly"),
				pattern = { "tex", "plaintex" },
				callback = function()
					vim.b.auto_save = 1
				end,
			})
		end,
	},
	-- copilot
	--{ "github/copilot.vim" },
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		-- 兼容 nvim 0.9.3 的跨端固定版本；0.11.6 的撤销越界问题在 yj.lua 中做运行时规避
		--commit = "cfc6f2c",
		build = ":TSUpdate",
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
