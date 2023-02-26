
" Restore to the position where it was last closed{
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"}

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)


" Set include path -> use "gf" jump {
set path=/usr/local/include
set path+=~/Library/Android/sdk/ndk/21.1.6352462/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include
set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include
set path+=~/Downloads/OpenCV-android-sdk/sdk/native/jni/include
"}


" Command {  "auto merge text to one line
:command -range=% Line :<line1>,<line2>s/\n/ /g
"}

" Attribute {
set clipboard=unnamed  "共享剪贴板
set autoindent "自动缩进
set cindent
"}

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
set mousemodel=popup
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
" }

" Cursor {
set guicursor=a:ver25-blinkon10
"set ruler
set nonumber
"set cursorline
set scrolloff=3
"}

" Tab {
set list                      " Show tabs differently
set listchars=tab:>-          " Use >--- for tabs
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
""}

"" Key-mapping {
" Abbreviations {
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev W: w
cnoreabbrev w: w
cnoreabbrev Q q
cnoreabbrev Qall qall
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

" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

" Tabs
nnoremap <Tab> gt
nnoremap <S-Tab> gT
nnoremap <silent> <S-t> :tabnew<CR>

" Terminal {
nnoremap <silent> <Leader>t :terminal<CR>
" exit 'terminal' mode
:tnoremap <Esc> <C-\><C-n>
"}

" Set working directory
nnoremap <Leader>. :lcd %:p:h<CR>

" Buffer nav
noremap <Leader>q :bp<CR>
noremap <Leader>w :bn<CR>

" Close buffer
noremap <Leader>c :bd<CR>

" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>
" }
"" }

"" Plugins {
let s:vim_plug_dir=expand('~/.config/nvim/autoload')
" Vim-Plug {
if !filereadable(s:vim_plug_dir.'/plug.vim')
  execute '!wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P '.s:vim_plug_dir
  let s:install_plug=1
endif

set completeopt-=preview " 关闭弹窗

call plug#begin('~/.config/nvim/plugged')
Plug 'Shougo/unite.vim' "弃用
"Plug 'Shougo/neomru.vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "代码提示 .可以提示snippet的代码
"Plug 'Shougo/ddc.vim'
"Plug 'vim-denops/denops.vim'
"Plug 'zchee/deoplete-jedi' "自动提示代码 python
"Plug 'Shougo/deoplete-clangx' "自动提示代码 C/C++
"Plug 'rhysd/vim-clang-format' " code format
"Plug 'mbbill/undotree' "可视化撤销历史记录
Plug 'scrooloose/nerdtree' "打开目录窗口（适合作为ide使用）
"Plug 'tpope/vim-commentary' "批量块注释代码
Plug 'airblade/vim-gitgutter'  "配合git 左边显示更改、删除行标记
Plug 'tpope/vim-fugitive' "vim 里面执行git操作如:Git diff
Plug 'sheerun/vim-polyglot' "语法高亮，coc.vim 也可以实现
Plug 'dense-analysis/ale' "保存文件才进行语法检查
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 0
let g:ale_linters_explicit = 1 " 关闭所有语言
"关闭python检查，这个太麻烦了
let g:ale_linters = {
      \   'python': ['eslint'],
      \}

"Plug 'sbdchd/neoformat'
Plug 'vim-autoformat/vim-autoformat'
"au BufWrite * :Autoformat "保存文件时格式化代码
"python 格式化需要安装 pip install autopep8

Plug 'neoclide/coc.nvim', {'branch': 'release'} "非常强大
"vim -> :CocInstall coc-clangd coc-jedi coc-sh  coc-java coc-html coc-texlab coc-rome  coc-texlab coc-vimlsp coc-highlight coc-git coc-tsserver coc-cmake
"CocInstall -> https://github.com/neoclide/coc.nvim/wiki/Using-coc-extensions
"Coc 自动导入包 CocAction 类似于java import 包
"显示snipt片段的提示 CocInstall coc-snippets
set hidden
set updatetime=100
"set shortmess+=c
inoremap <expr> <Down> coc#pum#visible() ? coc#pum#next(1) : "\<Down>"
inoremap <expr> <Up> coc#pum#visible() ? coc#pum#prev(1) : "\<Up>"
inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

"Plug 'majutsushi/tagbar' "需要执行`:Tagbar`命令 可查看代码大纲
Plug 'bronson/vim-trailing-whitespace' "多余的空格自动报红
"Plug 'editorconfig/editorconfig-vim' "回车自动缩进
"======================================================================
" Color thems
Plug 'junegunn/seoul256.vim'
setlocal spell
set spelllang=en_us
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
"======================================================================
" Markdown
Plug 'godlygeek/tabular' "必要插件，安装在vim-markdown前面
"Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
let g:vim_markdown_folding_disabled = 1 "禁用折叠
"let g:vim_markdown_folding_level = 6 "折叠层级默认为1
let g:vim_markdown_conceal = 0 "禁用隐藏
let g:tex_conceal = ""
let g:vim_markdown_math = 1 "开启数学公式高亮
let g:vim_markdown_fenced_languages = ['csharp=cs'] " 添加指定代码围栏
"let g:vim_markdown_conceal_code_blocks = 0 "禁用代码围栏

"======================================================================
"Ultisnips
Plug 'SirVer/ultisnips'
Plug 'keelii/vim-snippets'
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'
"======================================================================
"网页预览markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
let g:mkdp_theme ='light'
"let g:mkdp_browser = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
"======================================================================
Plug 'rcarriga/nvim-notify'
call plug#end()

"弹窗美化比如 :lua vim.notify("This is an error message", "error")
lua vim.notify = require("notify")

if exists('s:install_plug')
  augroup PlugInstall
    au!
    au VimEnter * PlugInstall
  augroup END
endif
" }

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
noremap <F2> :NERDTreeToggle<CR>
" Close NERDTree if no other window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }

" vim-commentray {
" to support other file type
" autocmd FileType apache setlocal commentstring=#\ %s
" }

" fugitive-git {
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
" }

" Color-thems {
colorscheme seoul256
" }

"Auto add Executive authority{
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent execute "!chmod +x <afile>" | endif | endif
" }

"Auto add FileContent{
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()"
func SetTitle()
  if &filetype == 'sh'
    call setline(1, "#!/bin/bash")
  endif
  if &filetype == 'cpp'
    call setline(1, "#include<iostream>")
    call setline(2, "")
  endif
  if &filetype == 'c'
    call setline(1, "#include<stdio.h>")
    call setline(2,"")
  endif
  if &filetype == 'python'
    call setline(1, "#!/usr/local/bin/python3.9")
  endif
  if &filetype == 'java'
    call setline(1,"public class ".expand("%"))
  endif
  if &filetype == 'dosini' "url
    call setline(1,"public class ".expand("%"))
  endif
  autocmd BufNewFile * normal G
endfunc
" }

"One-click operation{
":echo expand('%:t')     my.txt  name of file ('tail')
":echo expand('%:p')     /abc/def/my.txt full path
":echo expand('%:p:h')   /abc/def    directory containing file ('head')
":echo expand('%:p:h:t') def First get the full path with :p (/abc/def/my.txt), then get the head of that with :h (/abc/def), then get the tail of that with :t (def)
":echo expand('%:r')     my  name of file less one extension ('root')
":echo expand('%:e')     txt name of file's extension ('extension')```

map <C-h> :call IntoHeadrFile()<CR>
func! IntoHeadrFile()
  let filename = expand('%:r')
  let filetype = expand('%:e')
  if filetype == 'cpp'
    exec 'e ' . filename . '.hpp'
  elseif filetype == 'hpp'
    exec 'e ' . filename . '.cpp'
  elseif filetype == 'c'
    exec 'e ' . filename . '.h'
  elseif filetype == 'h'
    exec 'e ' . filename . '.c'
  endif
endfunc

"map <C-b> :call Run()<CR>
func! Run()
  exec "w"
  if &filetype == 'c'
    exec '!gcc % -o %< -g -w  '
    exec '!./%<'
    "exec '!./%<'
  elseif &filetype == 'cpp'
    exec '!g++ % -o %< -g -w'
    exec '!./%<'
    "exec '!time ./%<'
  elseif &filetype == 'JavaScript'
    exec '!python3 ./exp.py'
    "exec '!time python3 ./exp.py'
  elseif &filetype == 'python'
    :"exec '!time python3 %'
    exec '!manim -pql % Demo'
    "exec '!time manim -pql % Demo'
  elseif &filetype == 'sh'
    :! ./%
    ":! bash %
  elseif &filetype == 'markdown'
    :MarkdownPreview
  endif
endfunc
" }
function Auto()
  :%!xxd
endfunction


" Unite {
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <Leader>f :<C-u>Unite file_rec/neovim<CR>
nnoremap <Leader>e :<C-u>Unite -no-split -buffer-name=mru file_mru<cr>
nnoremap <Leader>b :<C-u>Unite -quick-match buffer<cr>
nnoremap <Leader>r :<C-u>Unite -no-split -buffer-name=register register<CR>

" Start insert.
call unite#custom#profile('default', 'context', {
      \   'start_insert': 1
      \ })

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


