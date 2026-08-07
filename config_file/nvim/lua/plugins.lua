---@diagnostic disable: undefined-global

local api = vim.api
local fn = vim.fn
local g = vim.g
local helper = require("plugins_helper")

local HAS_MAC = fn.has("mac") == 1
local HAS_LINUX = fn.has("linux") == 1

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
    cond = helper.flag_enabled("is_coc_vim"),
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
          group = helper.create_augroup("CocLatexBootstrap"),
          pattern = "CocJumpPlaceholderPre",
          callback = function()
            if fn.exists("*coc#rpc#ready") == 1 and fn["coc#rpc#ready"]() == 0 then
              vim.cmd("silent! CocStart --channel-ignored")
            end
          end,
        })

        if HAS_MAC and fn.executable("texlab") == 0 then
          vim.schedule(function() vim.notify("Please use -> brew install --HEAD texlab", vim.log.levels.WARN) end)
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
      if g.is_latex == 1 then g.formatdef_latexindent = '"latexindent -"' end
      g.formatdef_nasmfmt = '"asmfmt"'
      g.formatters_nasm = { "nasmfmt" }
    end,
  },
  {
    "majutsushi/tagbar",
    cmd = { "TagbarClose", "TagbarOpen", "TagbarToggle" },
    init = function()
      g.tagbar_sort = 0
      g.tagbar_position = "belowright"
      g.tagbar_height = 10
      g.tagbar_width = 30
      vim.keymap.set("n", "<F2>", helper.toggle_tagbar_with_nerdtree_layout, { silent = true })
    end,
  },
  -- LaTeX
  {
    "lervag/vimtex",
    tag = "v2.15",
    cond = helper.flag_enabled("is_latex"),
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
      if HAS_MAC then defs[#defs + 1] = "\\def\\Mac{true}" end
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
        group = helper.create_augroup("VimtexPreviewMap"),
        pattern = "VimtexEventInitPost",
        callback = function(ev)
          vim.keymap.set("n", "\\v", "<Plug>(vimtex-view)", { buffer = ev.buf, remap = true, silent = true })
          vim.keymap.set("n", "'v", "<Plug>(vimtex-view)", { buffer = ev.buf, remap = true, silent = true })
        end,
      })
    end,
  },
  { "KeitaNakamura/tex-conceal.vim", ft = { "tex", "plaintex" }, cond = helper.flag_enabled("is_latex") },
  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    lazy = false,
    ft = { "markdown" },
    cond = helper.flag_enabled("is_markdown"),
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
    "preservim/nerdtree",
    init = function()
      helper.set_nerdtree_current_file_highlight()
      api.nvim_create_autocmd("ColorScheme", {
        group = helper.create_augroup("NERDTreeCurrentFileHighlight"),
        callback = helper.set_nerdtree_current_file_highlight,
      })

      g.NERDTreeChDirMode = 2
      g.NERDTreeShowHidden = 1
      g.NERDTreeShowBookmarks = 1
      g.NERDTreeHighlightCursorline = 1
      g.nerdtree_tabs_focus_on_files = 1
      g.NERDTreeMapOpenInTabSilent = "<RightMouse>"
      g.NERDTreeWinPos = "left"
      g.NERDTreeWinSize = 30

      api.nvim_create_autocmd("BufEnter", {
        group = helper.create_augroup("NERDTreeCloseLastWindow"),
        callback = function()
          vim.cmd([[if winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree() | quit | endif]])
        end,
      })
      api.nvim_create_autocmd("BufEnter", {
        group = helper.create_augroup("NERDTreeCurrentFileMarker"),
        callback = function(ev)
          if not helper.should_sync_nerdtree_current_file(ev.buf) then return end

          vim.schedule(function()
            if api.nvim_get_current_buf() == ev.buf then helper.sync_nerdtree_current_file() end
          end)
        end,
      })

      if g.is_vim_studio == 1 then
        api.nvim_create_autocmd("VimEnter", {
          group = helper.create_augroup("NERDTreeStudioAutoOpen"),
          nested = true,
          callback = function()
            local source_win = api.nvim_get_current_win()
            vim.cmd("NERDTreeFind")
            helper.mark_nerdtree_current_file()
            helper.open_tagbar_below_nerdtree()
            if api.nvim_win_is_valid(source_win) then api.nvim_set_current_win(source_win) end
          end,
        })
      end
    end,
    cmd = { "NERDTree", "NERDTreeFind", "NERDTreeToggle" },
    keys = {
      { "<leader>F", "<cmd>NERDTreeFind<CR>", mode = "n", silent = true },
      { "<leader>f", "<cmd>NERDTreeFind<CR><C-w>p", mode = "n", silent = true },
      { "<F1>", "<cmd>NERDTreeFind<CR><C-w>p", mode = "n", silent = true },
      --{ "<F1>", "<cmd>NERDTreeFind<CR>", mode = "n", silent = true },
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
        { "<leader>/", helper.nerdcommenter_toggle_normal, mode = "n", silent = true },
        { "<leader>/", helper.nerdcommenter_toggle_visual_keep, mode = "x", silent = true },
      }

      if HAS_LINUX then
        table.insert(keys, { "<C-_>", helper.nerdcommenter_toggle_normal, mode = "n", silent = true })
        table.insert(keys, { "<C-_>", helper.nerdcommenter_toggle_visual_move, mode = "x", silent = true })
      end

      return keys
    end,
  },
  {
    "rcarriga/nvim-notify",
    --version = "v3.13.5",
    cond = helper.flag_enabled("is_nvim_notify"),
    config = function() vim.notify = require("notify") end,
  },
  -- FZF
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },
  -- 自动保存
  {
    "907th/vim-auto-save",
    init = function()
      api.nvim_create_autocmd("FileType", {
        group = helper.create_augroup("AutoSaveTexOnly"),
        pattern = { "tex", "plaintex" },
        callback = function() vim.b.auto_save = 1 end,
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
}
