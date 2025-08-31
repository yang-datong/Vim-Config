-- =============================================================================================================================================================================
return {
  -- { "dense-analysis/ale" }, -- 主要是用clang-tidy
  -- { "Shougo/unite.vim" }, -- 跟Coc有点类似，但基本被Coc取代了，它的目标是建一个用户界面（UI），可以从各种不同的源（如文件、缓冲区、最近使用的文件或寄存器）中搜索和显示信息。你可以在 unite 窗口中对目标执行多个预定义的操作。比如：
-- 1. 显示文件和缓冲区：运行 :Unite file buffer，它会在 unite 窗口中列出当前目录中的所有文件和缓冲区，你可以通过按 j 和 k 键在列表中选择其中一个文件或缓冲区。
-- 2. 使用过滤器：如果你想筛选文件，可以运行 :Unite -input=foo file，其中 foo 是你的过滤条件。这将只显示文件名中包含 foo 的文件。
-- 类似与在vim里面重新配置一些“自己”的东西
  -- { "Shougo/deoplete.nvim", build = ":UpdateRemotePlugins" },  -- 代码提示 .可以提示snippet的代码
  -- ======================================================================
  -- 语法高亮与基础支持
  -- ======================================================================
  { "sheerun/vim-polyglot" }, -- 语法高亮，代码缩进

  -- ======================================================================
  -- Git 集成
  -- ======================================================================
  { "airblade/vim-gitgutter" }, -- 左边栏显示 Git 更改、删除行标记

  {
    "tpope/vim-fugitive", -- Git 命令封装
    config = function()
      -- 在 vim 插件世界中，一直有着“TPope 出品，必属精品”的说法
      vim.keymap.set("n", "<Leader>gs", ":Git<CR>", { silent = true, noremap = true })
      -- noremap <Leader>gb :Gblame<CR> "不知道怎么用
      vim.keymap.set("n", "<Leader>gd", ":Gvdiff<CR>", { silent = true, noremap = true })
      -- 很好用，再也不用使用cp new_file tmp && git restore new_file && vim -d new_file tmp了
    end,
  },

  -- ======================================================================
  -- 代码格式化
  -- ======================================================================
  {
    "vim-autoformat/vim-autoformat",
    init = function()
      -- NOTE: 请确保你已经手动安装了所需的格式化工具：
      -- Python: pip install autopep8
      -- C/C++: brew install clang-format 或 astyle
      -- Cmake : pip install cmake-format
      -- Markdown : npm install -g remark-cli
      -- Shell : apt install shfmt
      -- Asm : brew install asmfmt

      if vim.fn.system("command -v clang-format") == "" then
        print("警告: 未找到 clang-format，请手动安装。")
      end
      if vim.fn.system("command -v clangd") == "" then
        print("警告: 未找到 clangd，请手动安装。")
      end

      if vim.g.is_latex == 1 then
        -- Must -> brew install latexindent
        if vim.fn.has("mac") == 1 then
          if vim.fn.system("command -v latexindent") == "" then
            print("警告: 未找到 latexindent，请手动安装（brew install latexindent）。")
          end
          -- NOTE: 在Apple silicon中安装的/Library/TeX/texbin/latexindent有问题，需要手动通过brew install latexindent安装，同时还需要去掉高优先路径的执行权限：
          -- "$ chmod -x /Library/TeX/texbin/latexindent
        end
        -- NOTE: Ubuntu在安装的texlive是可以直接使用的
        vim.g.formatdef_latexindent = '"latexindent -"' -- 设置Autoformat的格式化插件为latexindent
      end
    end,
  },

  -- ======================================================================
  -- 语言服务与补全 (CoC)
  -- ======================================================================
  {
    "neoclide/coc.nvim",
    branch = "release",
    cond = vim.g.is_coc_vim,
    init = function()
      -- 自动安装Coc插件
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
        "coc-yaml",
      }

      if vim.g.is_latex == 1 and vim.fn.has("mac") == 1 then
        if vim.fn.system("command -v texlab") == "" then
          print("警告: 请使用 -> brew install --HEAD texlab")
        end
      end
    end,
    config = function()
      if vim.g.is_latex == 1 then
        vim.api.nvim_create_autocmd("User", {
          pattern = "CocJumpPlaceholderPre",
          callback = function()
            if vim.fn["coc#rpc#ready"]() == 0 then
              vim.cmd("silent! CocStart --channel-ignored")
            end
          end,
        })
      end
    end,
  },

  -- ======================================================================
  -- 代码大纲与标记
  -- ======================================================================
  {
    "majutsushi/tagbar", -- 查看代码大纲
    init = function()
      -- NOTE: 请确保已安装 ctags (macOS: brew install ctags, Linux: sudo apt install universal-ctags)
      vim.g.tagbar_sort = 0 -- 关闭函数等排序
    end,
    config = function()
      vim.keymap.set("n", "<F2>", ":TagbarToggle<CR>", { silent = true, noremap = true })
      if vim.g.is_vim_studio == 1 then
        vim.api.nvim_create_autocmd("VimEnter", {
          pattern = "*",
          nested = true,
          command = "TagbarOpen",
        })
      end
    end,
  },

  { "chentoast/marks.nvim" }, -- 左边栏显示当前mark标记

  -- ======================================================================
  -- 主题
  -- ======================================================================
  -- Dark
  { "junegunn/seoul256.vim" },
  { "shaunsingh/nord.nvim" }, -- Math style
  { "Mofiqul/vscode.nvim" },
  -- { "doums/darcula" },
  -- { "dylanaraps/wal" },
  -- { "morhetz/gruvbox" },
  -- Light
  { "nyoom-engineering/oxocarbon.nvim" },

  -- ======================================================================
  -- 代码片段
  -- ======================================================================
  {
    "SirVer/ultisnips",
    init = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<S-tab>"
    end,
  },
  {
    "keelii/vim-snippets",
    dependencies = { "SirVer/ultisnips" },
  },

  -- ======================================================================
  -- LaTeX 支持
  -- ======================================================================
  {
    "lervag/vimtex",
    tag = "v2.14", -- 锁定版本
    cond = vim.g.is_latex == 1,
    init = function()
      vim.g.vimtex_quickfix_mode = 0
      vim.g.tex_flavor = "latex"
      if vim.fn.has("mac") == 1 then
        -- Use Skim (Skim的字体展示会比较黑,但是zathura配置很麻烦）
        vim.g.vimtex_view_general_viewer = "skim"
        vim.g.vimtex_view_method = "skim"
        -- 在skim中-同步：
        -- 预设：自定义
        -- 命令：nvim
        -- 参数：--headless -c "VimtexInverseSearch %line '%file'"
      elseif vim.fn.has("linux") == 1 then
        -- Use zathura
        vim.g.vimtex_view_general_viewer = "zathura"
        vim.g.vimtex_view_method = "zathura"
      end
      -- 是否转移焦点到PDF预览器中
      vim.g.vimtex_view_skim_sync = 0
      vim.g.vimtex_view_skim_activate = 0

      -- 设置 Vimtex 使用的默认编译器程序为 Neovim Remote（nvr）
      vim.g.vimtex_compiler_progname = "nvr"

      local macro_definition = ""
      if vim.g.latex_full_compiled_mode == 0 then
        if vim.fn.has("mac") == 1 then
          macro_definition = "\\def\\Mac{true}"
        end
      else -- 全编译模式
        macro_definition =
        "\\def\\StandardModel{true}\\def\\ShowAfterClassExercises{true}\\def\\UseInkscapeTools{true}"
      end

      vim.g.vimtex_compiler_latexmk = {
        executable = "latexmk",
        options = {
          "-file-line-error",
          "-synctex=1",
          "-interaction=batchmode",
          "-pretex=" .. vim.fn.shellescape(macro_definition),
          "-usepretex",
        },
      }
    end,
  },
  {
    "KeitaNakamura/tex-conceal.vim",
    ft = { "tex" }, -- 仅在 tex 文件加载
    init = function()
      vim.g.tex_conceal_frac = 1
      vim.g.tex_superscripts = "[0-9a-zA-W.,:;+-<>/()=]"
      vim.g.tex_subscripts = "[0-9aehijklmnoprstuvx,+-/().]"
      vim.g.tex_conceal = "abdmg"
    end,
    config = function()
      vim.opt.conceallevel = 2
      vim.cmd("hi Conceal ctermbg=none")
    end,
  },

  -- ======================================================================
  -- Markdown 支持
  -- ======================================================================
  {
    "iamcco/markdown-preview.nvim",
    cond = vim.g.is_markdown == 1,
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = { "markdown", "vim-plug" },
    init = function()
      vim.g.mkdp_theme = "dark"
      if vim.fn.has("mac") == 1 then
        vim.g.mkdp_browser = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      else
        vim.g.mkdp_browser = "/usr/bin/google-chrome-stable"
      end
    end,
    config = function()
      vim.api.nvim_create_autocmd("FileType", { pattern = "math", command = "set filetype=markdown" })
      vim.api.nvim_create_autocmd("FileType", { pattern = "math", command = "set filetype=tex" })
    end,
  },

  -- ======================================================================
  -- 文件浏览器
  -- ======================================================================
  {
    "scrooloose/nerdtree",
    init = function()
      vim.opt.wildignore:append("*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,.git")
      vim.g.NERDTreeChDirMode = 2
      vim.g.NERDTreeShowHidden = 1
      vim.g.NERDTreeIgnore = { ".out$", ".cmake$", ".vim$", ".git", "CMakeCache.txt", "CMakeFiles", "__pycache__" }
      vim.g.NERDTreeShowBookmarks = 1
      vim.g.nerdtree_tabs_focus_on_files = 1
      vim.g.NERDTreeMapOpenInTabSilent = "<RightMouse>"
      vim.g.NERDTreeWinSize = 30
    end,
    config = function()
      vim.keymap.set("n", "<F1>", ":NERDTreeToggle<CR>", { silent = true, noremap = true })
      -- Close NERDTree if no other window open
      -- autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
      -- vim.api.nvim_create_autocmd("BufEnter", {
      --   pattern = "*",
      --   callback = function()
      --     if vim.fn.winnr("$") == 1 and vim.b.NERDTree and vim.b.NERDTree.isTabTree() then
      --       vim.cmd("q")
      --     end
      --   end,
      -- })
      if vim.g.is_vim_studio == 1 then
        vim.api.nvim_create_autocmd("VimEnter", {
          pattern = "*",
          nested = true,
          command = "NERDTreeToggle",
        })
      end
    end,
  },

  -- ======================================================================
  -- 注释工具
  -- ======================================================================
  {
    "preservim/nerdcommenter",
    init = function()
      vim.g.NERDCustomDelimiters = {
        c = { left = "/* ", right = " */" },
        asm = { left = "// " },
      }
    end,
    config = function()
      vim.keymap.set("n", "<leader>/", [[:call nerdcommenter#Comment('n', 'toggle')<CR>:execute 'normal 0 j'<CR>]], { silent = true, noremap = true })
      vim.keymap.set("v", "<leader>/", [[:call nerdcommenter#Comment('x', 'invert')<CR>]], { silent = true, noremap = true })
      if vim.fn.has("linux") == 1 then
        vim.keymap.set("n", "<C-_>", [[:call nerdcommenter#Comment('n', 'toggle')<CR>:execute 'normal 0 j'<CR>]], { silent = true, noremap = true })
        vim.keymap.set("v", "<C-_>", [[:call nerdcommenter#Comment('x', 'invert')<CR>:execute 'normal 0 j'<CR>]], { silent = true, noremap = true })
      end
    end,
  },

  -- ======================================================================
  -- 模糊搜索
  -- ======================================================================
  {
    "junegunn/fzf",
    build = function()
      vim.fn["fzf#install"]()
    end,
    config = function()
      -- NOTE: 请确保已安装 fzf 和 the_silver_searcher (ag)
      -- brew install fzf the_silver_searcher
      -- sudo apt install fzf silversearcher-ag
    end,
  },
  {
    "junegunn/fzf.vim",
    dependencies = { "junegunn/fzf" },
  },

  -- { "github/copilot.vim" }, 
  -- 首次安装时，需要执行:Copilot setup，然后从github上面认证后，才可以使用
  -- 每个月都有限额（免费的）

  -- ======================================================================
  -- 其他工具
  -- ======================================================================
  { "nvim-treesitter/nvim-treesitter" }, -- 现代语法高亮引擎

  {
    "rcarriga/nvim-notify", -- 漂亮的通知
    cond = vim.fn.has("nvim") == 1 and vim.g.is_nvim_notify == 1,
  },

  { "deris/vim-shot-f" }, -- 高亮f/F,t/T命令

  -- { "nvim-tree/nvim-tree.lua" }, 和NERDTreeToggle差不多
  -- { "akinsho/bufferline.nvim" }, -- 重新排序选项卡
  {
    "907th/vim-auto-save", -- 自动保存
    config = function()
      vim.g.auto_save = 0
      if vim.bo.filetype == "tex" or vim.bo.filetype == "plaintex" then
        vim.api.nvim_create_augroup("ft_tex", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
          pattern = "tex",
          group = "ft_tex",
          callback = function()
            vim.b.auto_save = 1 -- 对于Latex时，自动执行保存文件
          end,
        })
      end
    end,
  },

}
