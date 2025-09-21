vim.opt.termguicolors = true

--============================== UltiSnips ========================================
function GetAllSnippets()
  vim.cmd('call UltiSnips#SnippetsInCurrentScope(1)')
  local list = {}
  for key, info in pairs(vim.g.current_ulti_dict_info) do
    table.insert(list, key)
  end
  table.sort(list)

  local show = ""
  local tmp = list[1]
  for _, cmd in ipairs(list) do
    if cmd:sub(1, 1) == tmp:sub(1, 1) then
      show = show .. cmd .. "\t"
    else
      show = show .. "\n" .. cmd .. "\t"
      tmp = cmd
    end
  end

  vim.notify(show, "info", {
      title = "List of all available snippets for the current file",
      on_open = function(win)
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
      end,
    })

end

--============================== Coc vim ========================================
--coc的函数补充后使用<C-j> <C-k>来跳转到上、下参数
vim.opt.updatetime = 300 -- or 100
local keyset = vim.keymap.set
local opts = {silent = true, noremap = true, expr = true, replace_keycodes = false}
keyset("i", "<Down>", 'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "<Down>" : coc#refresh()', opts)
keyset("i", "<Up>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"]], opts)
keyset("i", "<cr>", [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]], opts)
-- 检查光标是否在一行的开头，或者光标前面的字符是否是空白字符

function _G.CheckBackspace()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
keyset("n", "[g", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "]g", "<Plug>(coc-diagnostic-next)", {silent = true})

-- "" Coc-vim jump definition
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})  --全能包括了vim默认的gf功能
if vim.bo.filetype == 'cpp' or vim.bo.filetype == 'c' or vim.bo.filetype == 'hpp' or vim.bo.filetype == 'h' or vim.api.nvim_get_var('is_vim_studio') == 1 then
  keyset("n", "gf", "<Plug>(coc-definition)", {silent = true})
end
keyset("n", "gt", "<Plug>(coc-type-definition)", {silent = true}) --对变量使用，比如对uint8_t使用会跳到typedef处，但是gd也可以跳，目前不太清楚有什么区别
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true}) --貌似没什么用
keyset("n", "gr", "<Plug>(coc-references)", {silent = true}) --通过小窗口的方式，查看交叉引用

-- Remap keys for apply code actions at the cursor position.
local opts = {silent = true, nowait = true}
keyset("x", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>a", "<Plug>(coc-codeaction-selected)", opts)

keyset("n", "<leader>ac", "<Plug>(coc-codeaction-cursor)", opts)
-- Remap keys for apply source code actions for current file.
keyset("n", "<leader>as", "<Plug>(coc-codeaction-source)", opts)
keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts) --快速修复操作代码建议
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true}) --当前文件内字符共同重新命令

-- Remap keys for apply refactor code actions.
keyset("n", "<leader>re", "<Plug>(coc-codeaction-refactor)", { silent = true })
keyset("x", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })
keyset("n", "<leader>r", "<Plug>(coc-codeaction-refactor-selected)", { silent = true })

keyset("n", "<C-c>", "<Plug>(coc-cursors-position)", {silent = true})
keyset("n", "<C-x>", "<Plug>(coc-cursors-word)", {silent = true})
keyset("x", "<C-x>", "<Plug>(coc-cursors-range)", {silent = true})

vim.api.nvim_create_augroup('CocGroup', {})

-- 高亮显示符号及其引用（鼠标处于空闲状态） 
--vim.api.nvim_create_autocmd('CursorHold', {
  --group = 'CocGroup',
  --command = "silent call CocActionAsync('highlight')",
  --desc = 'Highlight symbol under cursor on CursorHold'
--})

-- Update signature help on jump placeholder
vim.api.nvim_create_autocmd('User', {
  group = 'CocGroup',
  pattern = 'CocJumpPlaceholder',
  command = "call CocActionAsync('showSignatureHelp')",
  desc = 'Update signature help on jump placeholder'
})

--======================================================================
--" Option {
--  "CocInstall coc-clangd coc-jedi coc-sh  coc-java coc-html coc-rome  coc-texlab coc-vimlsp coc-highlight coc-git coc-tsserver coc-cmake coc-json
--    "- CocInstall -> https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
--  "语法检查：
--    "- python : CocInstall coc-pyright
--    "- js : coc-eslint
--    "- shell: brew install shellcheck
--  "显示snipt片段的提示:
--    "- CocInstall coc-snippets
--  "clangd 配置语法识别参数:
--    "- 文件在 用户目录下的 compile_flags.txt文件，比如配置头文件路径
--  "Coc 自动导入包 CocAction 类似于java import 包
--
--  "卸载：
--    "- :CocList extensions
--    "- 选中按<Tab> 再按u



--============================== Notify ====================================
local coc_status_record = {}

function coc_status_notify(msg, level)
  local notify_opts = { title = "LSP Status", timeout = 500, hide_from_history = true, on_close = reset_coc_status_record }
  -- if coc_status_record is not {} then add it to notify_opts to key called "replace"
  if coc_status_record ~= {} then
    notify_opts["replace"] = coc_status_record.id
  end
  coc_status_record = vim.notify(msg, level, notify_opts)
end

function reset_coc_status_record(window)
  coc_status_record = {}
end

local coc_diag_record = {}

function coc_diag_notify(msg, level)
  local notify_opts = { title = "LSP Diagnostics", timeout = 500, on_close = reset_coc_diag_record }
  -- if coc_diag_record is not {} then add it to notify_opts to key called "replace"
  if coc_diag_record ~= {} then
    notify_opts["replace"] = coc_diag_record.id
  end
  coc_diag_record = vim.notify(msg, level, notify_opts)
end

function reset_coc_diag_record(window)
  coc_diag_record = {}
end

--============================== Vim-Marks ====================================
require'marks'.setup {
  default_mappings = true,
  builtin_marks = { ".", "<", ">", "^" },
  cyclic = true,
  force_write_shada = false,
  refresh_interval = 250,
  sign_priority = { lower=10, upper=15, builtin=8, bookmark=20 },
  excluded_filetypes = {},
  excluded_buftypes = {},
  bookmark_0 = {
    sign = "⚑",
    virt_text = "hello world",
    annotate = false,
  },
  mappings = {}
}



--============================== nvim-Treesitter ===============================
require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { "bash", "c", "cpp", "python", "lua", "vim", "latex", "asm", "nasm", "yaml", "json", },
  sync_install = false,
  auto_install = true,
  highlight = {
    enable = true,
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        else --除了汇编语言都关闭
            return lang ~= "asm"
        end
    end,
   additional_vim_regex_highlighting = false,
  },
}
