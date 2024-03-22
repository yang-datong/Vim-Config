-- vim.notify("This is an error message", "error")
-- require("notify")("My super important message")
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

-- "" Coc-vim jump definition
keyset("n", "gd", "<Plug>(coc-definition)", {silent = true})  --全能包括了vim默认的gf功能
if not vim.bo.filetype == 'tex'  then
  keyset("n", "gf", "<Plug>(coc-definition)", {silent = true}) --不使用vim的gf
end
keyset("n", "gt", "<Plug>(coc-type-definition)", {silent = true}) --对变量使用，比如对uint8_t使用会跳到typedef处，但是gd也可以跳，目前不太清楚有什么区别
keyset("n", "gi", "<Plug>(coc-implementation)", {silent = true}) --貌似没什么用
keyset("n", "gr", "<Plug>(coc-references)", {silent = true}) --通过小窗口的方式，查看交叉引用

keyset("n", "<leader>qf", "<Plug>(coc-fix-current)", opts) --快速修复操作代码建议
keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true}) --当前文件内字符共同重新命令

keyset("n", "<C-c>", "<Plug>(coc-cursors-position)", {silent = true})
keyset("n", "<C-x>", "<Plug>(coc-cursors-word)", {silent = true})
keyset("x", "<C-x>", "<Plug>(coc-cursors-range)", {silent = true})
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
