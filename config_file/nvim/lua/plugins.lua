local function flag_enabled(name)
  local value = vim.g[name]
  return value == nil or value == 1
end

return {
  -- 基础工具
  { "Shougo/unite.vim", lazy = false },
  { "airblade/vim-gitgutter", lazy = false },
  {
    "chentoast/marks.nvim",
    lazy = false,
    config = function()
      require("marks").setup({})
    end,
  },
  { "tpope/vim-fugitive", lazy = false },
  { "sheerun/vim-polyglot", lazy = false },
  { "vim-autoformat/vim-autoformat", lazy = false },
  {
    "neoclide/coc.nvim",
    branch = "release",
    lazy = false,
    cond = flag_enabled("is_coc_vim"),
  },
  { "majutsushi/tagbar", lazy = false },
  -- 主题
  { "junegunn/seoul256.vim", lazy = false, priority = 1000 },
  { "shaunsingh/nord.nvim", lazy = false },
  { "Mofiqul/vscode.nvim", lazy = false },
  { "nyoom-engineering/oxocarbon.nvim", lazy = false },
  -- 代码片段
  { "SirVer/ultisnips", lazy = false },
  { "keelii/vim-snippets", lazy = false },
  -- LaTeX
  {
    "lervag/vimtex",
    tag = "v2.14",
    lazy = false,
    cond = flag_enabled("is_latex"),
  },
  {
    "KeitaNakamura/tex-conceal.vim",
    ft = { "tex", "plaintex" },
    cond = flag_enabled("is_latex"),
  },
  -- Markdown
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown", "vim-plug" },
    cond = flag_enabled("is_markdown"),
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  -- 文件/注释/通知等
  { "scrooloose/nerdtree", lazy = false },
  { "preservim/nerdcommenter", lazy = false },
  {
    "rcarriga/nvim-notify",
    cond = function()
      return vim.fn.has("nvim") == 1 and flag_enabled("is_nvim_notify")
    end,
    config = function()
      vim.notify = require("notify")
    end,
  },
  { "deris/vim-shot-f", lazy = false },
  -- FZF
  {
    "junegunn/fzf",
    lazy = false,
    build = function()
      vim.fn["fzf#install"]()
    end,
  },
  {
    "junegunn/fzf.vim",
    lazy = false,
    dependencies = { "junegunn/fzf" },
  },
  -- 自动保存
  { "907th/vim-auto-save", lazy = false },
  -- copilot
  --{ "github/copilot.vim", lazy = false },
  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
  },
}
