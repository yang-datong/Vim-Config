" CATALOGUE OUTLINE:
"1. 基本配置区域
"2. 按键映射区域
"3. 插件配置区域
"4. 自定义命令、按键区域
"5. 自动执行命令区域
"6. unite插件扩展区域

">注意! cpp\hpp 文件的&filetype变量都是cpp
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     1. 基本配置区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set include path -> use "gf" jump {
if has("mac")
  let g:python3_host_prog='/usr/local/bin/python3.9' "Mac -> Open
  set path+=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include/c++/v1
  set path+=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include
  set path+=~/Library/Android/sdk/ndk/21.1.6352462/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include "Android JNI
endif
" }
" Attribute {
if has("mac")
  set clipboard=unnamed  "共享剪贴板
else
  set clipboard=unnamedplus
endif
set autoindent "自动缩进
set cindent
" }
" Search {
set hlsearch
set incsearch
set ignorecase
set smartcase
" }
" Others {
set fileformats=unix,dos,mac
set showcmd
set hidden
set backspace=indent,eol,start    " Fix backspace indent
"set mousemodel=popup " GUI Vim effect
set mouse= "Remove mouse operation
" }
" Visual {
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
" }
" Basic {
set nolinebreak               " don't wrap at words, messes up copy
set visualbell
set wildmode=longest,list,full
set wildmenu
set numberwidth=3     " minimun width to use for the number column.
" }
" Syntax {
syntax on
syntax enable
"set foldmethod=syntax
"set foldlevel=2
" }
" Cursor {
set guicursor=a:ver25-blinkon10
"set ruler
set nonumber
"set cursorline
set scrolloff=3
"}
" Tab {
"set list                      " Show tabs differently
"set listchars=tab:>-          " Use >--- for tabs
" }
" Status {
set title
set titleold="Terminal"
set titlestring=%F
set noshowmode
set noruler
set laststatus=0
set noshowcmd
" }
" Close the pop-up window {
" 影响主要是在编写代码时会弹出函数定义框，需要手动关闭影响布局
"set completeopt-=preview
" }

""}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      2. 按键映射区域                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key-mapping {
" Abbreviations {
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev W w
cnoreabbrev W: w
cnoreabbrev w: w
cnoreabbrev Q q
cnoreabbrev Qall qall
cnoreabbrev qAll qall
cnoreabbrev Wall wall
cnoreabbrev wAll wall
cnoreabbrev Wqall! wqall!
cnoreabbrev Wqall wqall
cnoreabbrev WQall! wqall!
cnoreabbrev WQall wqall
cnoreabbrev wQall! wqall!
cnoreabbrev wQall wqall
"}

" Mapping {
" Map Leader to ,
let mapleader=','

" Window navigation {
" Allow Alt + {h, j, k, l} to navigate between windows
" In all mode including Terminal
if has("mac")
  " Alt+h,j,k,l ==> ˙,∆,˚,¬
  :tnoremap ˙ <C-\><C-n><C-w>h
  :tnoremap ∆ <C-\><C-n><C-w>j
  :tnoremap ˚ <C-\><C-n><C-w>k
  :tnoremap ¬ <C-\><C-n><C-w>l
  :nnoremap ˙ <C-w>h
  :nnoremap ∆ <C-w>j
  :nnoremap ˚ <C-w>k
  :nnoremap ¬ <C-w>l
else
  :tnoremap <A-h> <C-\><C-n><C-w>h
  :tnoremap <A-j> <C-\><C-n><C-w>j
  :tnoremap <A-k> <C-\><C-n><C-w>k
  :tnoremap <A-l> <C-\><C-n><C-w>l
  :nnoremap <A-h> <C-w>h
  :nnoremap <A-j> <C-w>j
  :nnoremap <A-k> <C-w>k
  :nnoremap <A-l> <C-w>l
endif
" }


" Fix word spell {
setlocal spell
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <C-l> mz[s1z=`]`z
" }
" Auto add symbols and  line break at the end {
"nnoremap ; A;<Esc>o
" }
" Hex model edit{
nnoremap <Leader>x :%!xxd<CR>
" }
" Split {
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>
" }
" Tabs {
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>
" }
" Terminal {
nnoremap <silent> <Leader>t :terminal<CR>
" exit 'terminal' mode
:tnoremap <Esc> <C-\><C-n>
"}
" Set working directory {
nnoremap <Leader>. :lcd %:p:h<CR>
" }
" Buffer nav {
noremap <Leader>q :bp<CR>
noremap <Leader>w :bn<CR>
" }
" Close buffer {
noremap <Leader>c :bd<CR>
" }
" Clean search (highlight) {
nnoremap <silent> <leader><space> :noh<cr>
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      3. 插件配置区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugins {
if has("nvim")
  let s:vim_plug_dir=expand('~/.config/nvim/autoload')
else
  let s:vim_plug_dir=expand('~/.vim/autoload')
endif
" Vim-Plug {
if !filereadable(s:vim_plug_dir.'/plug.vim')
  execute '!wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P '.s:vim_plug_dir
  let s:install_plug=1
endif

if has("nvim")
  call plug#begin('~/.config/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif
"======================================================================
Plug 'Shougo/unite.vim'
"======================================================================
"Plug 'Shougo/neomru.vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "代码提示 .可以提示snippet的代码
Plug 'Shougo/ddc.vim'
"======================================================================
Plug 'airblade/vim-gitgutter'  "配合git 左边显示更改、删除行标记
"======================================================================
Plug 'tpope/vim-fugitive' "vim 里面执行git操作如:Git diff
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
"======================================================================
Plug 'sheerun/vim-polyglot' "语法高亮，coc.vim 也可以实现
"======================================================================
Plug 'vim-autoformat/vim-autoformat'
"let g:autoformat_verbosemode=1 "调试format
if &filetype == 'cpp'
  au BufWrite * :Autoformat "保存文件时格式化代码
endif
  "python-格式化: pip install autopep8
  "C\C++\Java : 1.brew install clang-format 2.https://astyle.sourceforge.net 需要编译
  "Cmake : pip install cmake-format
  "Latex : brew install latexindent ,(必须添加->let g:formatdef_latexindent = '"latexindent -"')
  "let g:formatdef_latexindent = '"latexindent -"'
  "Markdown : npm install -g remark-cli
  "Shell : go install mvdan.cc/sh/v3/cmd/shfmt@latest (需要安装go)
"======================================================================
Plug 'neoclide/coc.nvim', {'branch': 'release'}
set hidden
set updatetime=100
inoremap <silent><expr> <Down>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Down>" :
      \ coc#refresh()
inoremap <expr> <Up> coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" https://github.com/neoclide/coc.nvim
" Coc-vim jump definition
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

"Must install -> let g:coc_global_extensions = ['coc-texlab']
autocmd User CocJumpPlaceholderPre if !coc#rpc#ready() | silent! CocStart --channel-ignored | endif "Latex

nmap <silent> <C-c> <Plug>(coc-cursors-position)
"nmap <silent> <C-d> <Plug>(coc-cursors-word) "冲突翻页
xmap <silent> <C-d> <Plug>(coc-cursors-range)
" use normal command like `<leader>xi(`
nmap <leader>x  <Plug>(coc-cursors-operator)


" Option {
  "CocInstall coc-clangd coc-jedi coc-sh  coc-java coc-html coc-rome  coc-texlab coc-vimlsp coc-highlight coc-git coc-tsserver coc-cmake coc-json
    "- CocInstall -> https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
  "语法检查：
    "- python : CocInstall coc-pyright
    "- js : coc-eslint
    "- shell: brew install shellcheck

  "显示snipt片段的提示: 
    "- CocInstall coc-snippets

  "clangd 配置语法识别参数: 
    "- 文件在 用户目录下的 compile_flags.txt文件，比如配置头文件路径

  "Coc 自动导入包 CocAction 类似于java import 包

  "卸载：
    "- :CocList extensions
    "- 选中按<Tab> 再按u
" }
"======================================================================
Plug 'majutsushi/tagbar' "需要执行`:Tagbar`命令 可查看代码大纲
let g:tagbar_position = 'vertical'
"Plug 'bronson/vim-trailing-whitespace' "加载这个插件会有冲突
noremap <F2> :TagbarToggle <CR>
"======================================================================
" Color thems
Plug 'junegunn/seoul256.vim'
Plug 'shaunsingh/nord.nvim' "Math style
Plug 'rafamadriz/neon'
"======================================================================
"Ultisnips
Plug 'SirVer/ultisnips'
Plug 'keelii/vim-snippets'
" Key mapping
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'
"======================================================================
Plug 'lervag/vimtex'
let g:vimtex_quickfix_mode=1
let g:tex_flavor = 'latex'
let g:vimtex_view_general_viewer = 'skim'
let g:vimtex_view_method = 'skim'
let g:vimtex_compiler_progname = 'nvr'
let g:vimtex_view_general_options = '-r @line @pdf @tex'

Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
"set conceallevel=2
let g:tex_conceal='abdmg'
hi Conceal ctermbg=none
"======================================================================
autocmd FileType math set filetype=markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
"Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
autocmd FileType math set filetype=tex
let g:mkdp_theme ='dark'
if has('mac')
  let g:mkdp_browser = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
  "let g:mkdp_browser = '/Applications/Firefox.app/Contents/MacOS/firefox'
  "let g:mkdp_browser = '/Applications/Firefox.app/Contents/MacOS/Safari'
else
  let g:mkdp_browser = '/usr/bin/google-chrome-stable'
endif

"======================================================================
Plug 'scrooloose/nerdtree'
" NERDTree {
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
let g:NERDTreeChDirMode=2
let NERDTreeShowHidden=1
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
"let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize=30

" NERDTree KeyMapping
" Locate current file in file systems
nnoremap <silent> <Leader>l :NERDTreeFind<CR>
noremap <C-1> :NERDTreeToggle<CR>
noremap <F1> :NERDTreeToggle<CR>
" Close NERDTree if no other window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }
"======================================================================
"Plug 'suan/vim-commentary'
" Vim-commentray {
" to support other file type
" autocmd FileType apache setlocal commentstring=#\ %s
" }
"======================================================================
if has("nvim")
  Plug 'rcarriga/nvim-notify'
endif
"======================================================================
call plug#end()

" Notify Configure {
"弹窗美化 :lua vim.notify("This is an error message", "error")
if has("nvim")
  lua vim.notify = require("notify")
endif
" }
" Themes Configure {
colorscheme seoul256
"colorscheme neon
"colorscheme nord
" }
" Unite Configure {
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <Leader>f :<C-u>Unite file_rec/neovim<CR>
nnoremap <Leader>e :<C-u>Unite -no-split -buffer-name=mru file_mru<cr>
nnoremap <Leader>b :<C-u>Unite -quick-match buffer<cr>
nnoremap <Leader>r :<C-u>Unite -no-split -buffer-name=register register<CR>
" Start insert.
call unite#custom#profile('default', 'context', { 'start_insert': 1 })
" }
if exists('s:install_plug')
  augroup PlugInstall
    au!
    au VimEnter * PlugInstall
  augroup END
endif
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  4. 自定义命令、按键区域                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check current line end char is ";" {
if &filetype == 'cpp'
  if has('mac')
    inoremap <expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-o>A<Esc>o" : "\<C-o>A;<Esc>o"
  elseif has('linux')
    inoremap <expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-Enter>" : "\<C-o>A;<Esc>o"
  endif
endif
"}

" Fast open configure file {
:command Config :e $MYVIMRC
"}

" Command {  "auto merge text to one line
:command -range=% Line :<line1>,<line2>s/\n/ /g
"}

" Show all snippets command {
func! GetAllSnippets()
  call UltiSnips#SnippetsInCurrentScope(1)
  let list = []
  for [key, info] in items(g:current_ulti_dict_info)
    call add(list, key)
  endfor
  return list
endfunc
"}

" Fast into head file {
map <C-h> :call IntoHeadrFile()<CR>
func! IntoHeadrFile()
  "let filename = expand('%:r')
  let filename = expand('%:t:r')
  let filetype = expand('%:e')
  if filetype == 'cpp'
    if filereadable(filename . '.hpp')
      " 当前目录存在文件头/源文件
      exec 'e ' . filename . '.hpp'
    else
      if filereadable('./include/' . filename . '.hpp')
      " 当前目录的include目录存在文件头/源文件
        exec 'e ./include/' . filename . '.hpp'
        echo "Into include/" . filename . '.hpp'
      else
        " 都不存在直接创建
        exec 'e ' . filename . '.hpp'
        echo "New create: " . filename . '.hpp'
      endif
    endif
  elseif filetype == 'hpp'
    if filereadable(filename . '.cpp')
      " 当前目录存在源文件
      exec 'e ' . filename . '.cpp'
    else
      if filereadable('../' . filename . '.cpp')
      " 上级目录的存在源文件
        exec 'e ../' . filename . '.cpp'
        echo "Into ../" . filename . '.cpp'
      else
        " 都不存在直接创建
        exec 'e ' . filename . '.cpp'
        echo "New create: " . filename . '.cpp'
      endif
    endif
  elseif filetype == 'c'
    exec 'e ' . filename . '.h'
  elseif filetype == 'h'
    exec 'e ' . filename . '.c'
  endif
endfunc
" }

" Fast start file execution {
map <M-r> :call Run()<CR>
func! Run()
  exec "w"
  if &filetype == 'c'
    let firstLine = getline(1)
    if stridx(firstLine, '//g++') == 0
      let remainingChars = strpart(firstLine, strlen('//g++'))
      echo remainingChars
      exec '!gcc % -o %< -g -w ' remainingChars '&& ./%<'
    else
      exec '!gcc % -o %< -g -w && ./%<'
    endif
  elseif &filetype == 'cpp'
    if filereadable('Makefile')
      exec '!make && ./a.out'
    else
      let firstLine = getline(1)
      if stridx(firstLine, '//g++') == 0
        let remainingChars = strpart(firstLine, strlen('//g++'))
        echo remainingChars
        exec '!g++ % -o %< -g -w ' remainingChars '&& ./%<'
      else
        exec '!g++ % -o %< -g -w && ./%<'
      endif
    endif
  elseif &filetype == 'JavaScript'
    exec '!python3 ./exp.py'
  elseif &filetype == 'python'
    "exec '!python3 %'
    exec '!manim -pql % Demo'
  elseif &filetype == 'manim'
    exec '!manim -pql % Demo'
  elseif &filetype == 'sh'
    :! bash %
  elseif &filetype == 'tex'
    :MarkdownPreview
  elseif &filetype == 'markdown'
    :MarkdownPreview
  endif
endfunc
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  5. 自动执行命令区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save mksession on vimleave {
if &filetype == 'cpp'
  autocmd VimLeave * mksession!
endif
"}

" Mathematics file {
autocmd FileType math colorscheme nord
autocmd FileType math UltiSnipsAddFiletypes markdown.snippets
autocmd FileType math set filetype=tex

autocmd FileType manim UltiSnipsAddFiletypes python.snippets
autocmd FileType manim set filetype=python
" }

" Restore to the position where it was last closed {
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }

"Auto add Executive authority{
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent execute "!chmod +x <afile>" | endif | endif
" }

"Auto add File Content{
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()"
func SetTitle()
  if &filetype == 'sh'
    call setline(1, "#!/bin/bash")
    call setline(2, "")
  endif
  if &filetype == 'cpp'
    call setline(1, "#include <iostream>")
    call setline(2, "")
  endif
  if &filetype == 'c'
    call setline(1, "#include <stdio.h>")
    call setline(2,"")
  endif
  if &filetype == 'python'
    call setline(1, "#!/usr/local/bin/python3.9")
  endif
  if &filetype == 'java'
    call setline(1,"public class ".expand("%"))
  endif
  autocmd BufNewFile * normal G
endfunc
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  6. unite插件扩展区域                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()"{{{
  " Overwrite settings.
  imap <buffer> jj      <Plug>(unite_insert_leave)
  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)

  imap <buffer><expr> j unite#smart_map('j', '')
  imap <buffer> <TAB>   <Plug>(unite_select_next_line)
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  imap <buffer> '     <Plug>(unite_quick_match_default_action)
  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
  imap <buffer><expr> x
        \ unite#smart_map('x', "\<Plug>(unite_quick_match_jump)")
  nmap <buffer> x     <Plug>(unite_quick_match_jump)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
  nnoremap <silent><buffer><expr> l
        \ unite#smart_map('l', unite#do_action('default'))

  let unite = unite#get_current_unite()
  if unite.profile_name ==# 'search'
    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
  else
    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
  endif

  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
  nnoremap <buffer><expr> S      unite#mappings#set_current_sorters(
        \ empty(unite#mappings#get_current_sorters()) ?

  " Runs "split" action by <C-s>.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
endfunction"}}}
" }

" deoplete {
  let g:deoplete#enable_at_startup = 1
  "let g:deoplete#enable_smart_case = 1

  "deoplete tab-complete
  inoremap <expr><tab> pumvisible() ? "\<c-n>" :"\<tab>"
  " }
  "" }
