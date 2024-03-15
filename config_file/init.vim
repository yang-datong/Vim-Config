" CATALOGUE OUTLINE:
"0. 变量控制区域
"1. 基本配置区域
"2. 按键映射区域
"3. 插件配置区域
"4. 自定义命令、按键区域
"5. 自动执行命令区域
"6. unite插件扩展区域

">注意! cpp\hpp 文件的&filetype变量都是cpp
















"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     0. 变量控制区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Whether to enable plug-in(0->off | 1->on){
let g:is_latex=1  "Latex
let g:is_markdown=0  "Markdown
let g:is_lua=1  "Lua config
" }
" Whether to enable plug-in(0->off | 1->on){
let g:latex_full_compiled_mode=0 "1：开启vimtex 编译传入参数 0：不传入参数
let g:is_vim_studio=0 "1：用工程开发试图开发vim 0：普通vim编辑模式(已添加到脚本vimm中，不需要手动调整）
let g:is_Android_jni=1 "1：将添加Android-JNI头文件到path中，0：不添加
"}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     1. 基本配置区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set include path -> use "gf" jump {
if has("mac")
  let g:python3_host_prog='/usr/local/bin/python3.9'
elseif has('linux')
  set path+=/usr/include/c++/11
  set path+=/usr/include/x86_64-linux-gnu/c++/11
  set path+=/usr/include/c++/11/backward
  set path+=/usr/lib/gcc/x86_64-linux-gnu/11/include
  set path+=/usr/local/include
  set path+=/usr/include/x86_64-linux-gnu
  set path+=/usr/include
endif

if g:is_Android_jni == 1
  if has("mac")
    set path+=expand('$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include')
  elseif has('linux')
    set path+=expand('$ANDROID_NDK_ROOT/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include')
  endif
endif
" }
" Attribute {
if has("mac")
  set clipboard=unnamed  "共享剪贴板
elseif has('linux')
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
set title "启用终端的标题栏显示当前编辑的文件名
set titleold="Terminal" "在Vim退出后，终端的标题将被设置为"Terminal"
set titlestring=%F "表示完整的文件路径显示
set noshowmode "关闭命令行模式提示，如 – INSERT – 等。
set noruler "关闭右下角的状态栏，不显示光标位置信息。
set laststatus=0 "设置状态行的显示方式，0表示不显示状态行。
set noshowcmd "在命令行不显示正在输入的命令。

if g:is_vim_studio == 1
  set number
  set laststatus=2
  set statusline=file:[%<%f],\ funciton:[%{coc#status()}%{get(b:,'coc_current_function','')}()]\ %=\ [%P]
"set statusline=%<%f\ %h%m%r%=\ %P
"%<%f：显示文件的完整路径。
"%h%m%r：显示文件的状态，h 代表帮助文件，m 代表修改过的文件，r 代表只读文件。
"%=：左右两边的内容平分状态栏。
"%-14.(%l,%c%V%)：显示光标位置，包括行号（%l）和列号（%c 和 %V）。
"%P：显示光标的百分比位置。
endif

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
elseif has('linux')
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
set spelllang=en_us,cjk
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
nnoremap <silent> <Tab> :wincmd w<CR> "切换窗口
"nnoremap <Tab> gt
"nnoremap <S-Tab> gT
"nnoremap <silent> <S-t> :tabnew<CR>
" }
" Terminal {
nnoremap <silent> <Leader>t :terminal<CR> "在vim中打开terminal
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

" fast show view in PDF {
if expand('%:e') == 'tex'
  nmap \v \lv
  nmap 'v \lv
endif
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
Plug 'Shougo/unite.vim' "跟Coc有点类似，但基本被Coc取代了，它的目标是建一个用户界面（UI），可以从各种不同的源（如文件、缓冲区、最近使用的文件或寄存器）中搜索和显示信息。你可以在 unite 窗口中对目标执行多个预定义的操作。比如：
"1. 显示文件和缓冲区：运行 :Unite file buffer，它会在 unite 窗口中列出当前目录中的所有文件和缓冲区，你可以通过按 j 和 k 键在列表中选择其中一个文件或缓冲区。
"2. 使用过滤器：如果你想筛选文件，可以运行 :Unite -input=foo file，其中 foo 是你的过滤条件。这将只显示文件名中包含 foo 的文件。
"类似与在vim里面重新配置一些“自己”的东西
"======================================================================
"Plug 'Shougo/neomru.vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' } "代码提示 .可以提示snippet的代码
"Plug 'Shougo/ddc.vim' "代码提示
"======================================================================
Plug 'airblade/vim-gitgutter'  "配合git 左边显示更改、删除行标记
"======================================================================
Plug 'tpope/vim-fugitive' "vim 里面执行git操作如:Git diff
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
"======================================================================
"Plug 'sheerun/vim-polyglot' "语法高亮，coc.vim 也可以实现
"======================================================================
Plug 'vim-autoformat/vim-autoformat'
"let g:autoformat_verbosemode=1 "调试format
autocmd FileType cpp autocmd BufWritePre <buffer> Autoformat
autocmd FileType tex autocmd BufWritePre <buffer> Autoformat
noremap <C-p> :Autoformat<CR>
  "python-格式化: pip install autopep8
  "C\C++\Java : 1.brew install clang-format 2.https://astyle.sourceforge.net 需要编译
if (system('command -v clang-format') =~ 'clang-format') == 0
  echo "Please use -> brew install clang-format"
endif
  "Cmake : pip install cmake-format
if g:is_latex == 1
  "Must -> brew install latexindent
  if (system('command -v latexindent') =~ 'latexindent') == 0
    echo "Please use -> brew install latexindent"
  endif
  let g:formatdef_latexindent = '"latexindent -"'  "设置格式化
endif
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
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" 检查光标是否在一行的开头，或者光标前面的字符是否是空白字符
" abort关键字用于在出现错误时立即终止函数
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" https://github.com/neoclide/coc.nvim
"nmap <silent> [g <Plug>(coc-diagnostic-prev)
"nmap <silent> ]g <Plug>(coc-diagnostic-next)
" Coc-vim jump definition
nmap <silent> gd <Plug>(coc-definition) "全能包括了vim默认的gf功能
nmap <silent> gf <Plug>(coc-definition) "不使用vim的gf
nmap <silent> gt <Plug>(coc-type-definition) "对变量使用，比如对uint8_t使用会跳到typedef处，但是gd也可以跳，目前不太清楚有什么区别
nmap <silent> gi <Plug>(coc-implementation) "貌似没什么用
nmap <silent> gr <Plug>(coc-references) "通过小窗口的方式，查看交叉引用
"nmap <leader>ac  <Plug>(coc-codeaction-cursor) "用于在光标位置应用代码操作的重映射键
"nmap <leader>as  <Plug>(coc-codeaction-source) "应用代码操作的重新映射键会影响整个缓冲区
nmap <leader>qf  <Plug>(coc-fix-current) "快速修复操作代码建议
nmap <leader>rn <Plug>(coc-rename) "当前文件内字符共同重新命令
nmap <silent> <C-c> <Plug>(coc-cursors-position)
nmap <silent> <C-x> <Plug>(coc-cursors-word) "冲突翻页
xmap <silent> <C-x> <Plug>(coc-cursors-range)

if g:is_latex == 1
  let g:coc_global_extensions = ['coc-texlab']
  autocmd User CocJumpPlaceholderPre if !coc#rpc#ready() | silent! CocStart --channel-ignored | endif "Latex

  if has('mac')
    if (system('command -v texlab') =~ 'texlab') == 0
      echo "Please use -> brew install texlab"
    endif
  endif
  "Must -> brew install --HEAD texlab
endif
let g:coc_global_extensions = ['coc-clangd'] "自动安装clangd
let g:coc_global_extensions = ['coc-snippets'] "自动安装snippets
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
"let g:tagbar_position = 'vertical'
"Plug 'bronson/vim-trailing-whitespace' "加载这个插件会有冲突
noremap <F2> :TagbarToggle <CR>
if g:is_vim_studio == 1
  autocmd VimEnter * nested :TagbarOpen
endif
"======================================================================
" Color thems
Plug 'junegunn/seoul256.vim'
Plug 'shaunsingh/nord.nvim' "Math style
"Plug 'dylanaraps/wal'
"Plug 'morhetz/gruvbox'
"======================================================================
"Ultisnips
Plug 'SirVer/ultisnips'
Plug 'keelii/vim-snippets'
" Key mapping
let g:UltiSnipsExpandTrigger = '<tab>'
let g:UltiSnipsJumpForwardTrigger = '<tab>'
let g:UltiSnipsJumpBackwardTrigger = '<S-tab>'
"======================================================================
if g:is_latex == 1
  Plug 'lervag/vimtex'
  let g:vimtex_quickfix_mode=0
  let g:tex_flavor = 'latex'
  if has('mac')
    " Use Skim 
    let g:vimtex_view_general_viewer = 'skim'
    let g:vimtex_view_method = 'skim'
    let g:vimtex_view_general_options = '-r @line @pdf @tex'
  elseif has('linux')
    " Use zathura 
    let g:vimtex_view_general_viewer = 'zathura'
    let g:vimtex_view_method='zathura'
    "let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'
  endif

  let g:vimtex_compiler_progname = 'nvr' 
    " 设置 Vimtex 使用的默认编译器程序为 Neovim Remote（nvr）。nvr 是一个 Neovim 的插件，用于在外部终端或窗口中运行编译命令。
  "let g:vimtex_compiler_pdflatex = {'options' : ['-interaction=batchmode']}

  if g:latex_full_compiled_mode == 0
    " 添加编译器参数： 编译器开启批处理模式
    " 类似于C的编译器参数
    if has('mac')
      let macro_definition = '\def\Mac{true}'
    else
      let macro_definition = ''
    endif
  else  " 全编译模式
    let macro_definition = ''
          \ .'\def\StandardModel{true}'
          \ .'\def\ShowAfterClassExercises{true}'
          \ .'\def\UseInkscapeTools{true}'
  "        \ .'\def\ReleaseModel{true}'
  endif

  let g:vimtex_compiler_latexmk = { 
        \ 'executable' : 'latexmk',
        \ 'options' : [ 
        \   '-file-line-error',
        \   '-synctex=1',
        \   '-interaction=batchmode',
        \   '-pretex=' . shellescape(macro_definition) ,
        \   '-usepretex'],
        \ }
        "\   '-jobname=' . expand('%:r') . '-全编译',
  "\   '-interaction=nonstopmode',
  "\   '-interaction=batchmode', "最低交互模式，编译速度最快
  "-synctex : 它允许您在 PDF 阅读器中点击某个位置，并在源代码中自动跳转到相应的位置，或者从源代码中定位到 PDF 中的具体位置
  "-interaction=nonstopmode : 禁止交互式操作。当 LaTeX 编译器遇到错误或需要用户输入时，默认情况下会暂停编译并等待用户响应。

  Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
  set conceallevel=2
  let g:tex_conceal='abdmg'
  hi Conceal ctermbg=none
  let g:tex_conceal_frac=1
endif
"======================================================================
if g:is_markdown == 1
  autocmd FileType math set filetype=markdown
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  autocmd FileType math set filetype=tex
  let g:mkdp_theme ='dark'
  if has('mac')
    "let g:mkdp_browser = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    "let g:mkdp_browser = '/Applications/Firefox.app/Contents/MacOS/firefox'
    let g:mkdp_browser = '/Applications/Firefox.app/Contents/MacOS/Safari'
  else
    let g:mkdp_browser = '/usr/bin/google-chrome-stable'
  endif
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
if g:is_vim_studio == 1
  autocmd VimEnter * nested :NERDTreeToggle
endif
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
Plug 'deris/vim-shot-f' "高亮f/F,t/T命令
"======================================================================
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"主要是使用 Files查找文件，以及Ag查找字符
"Ag功能需要额外安装：
"Mac: brew install the_silver_searcher
"Ubuntu: apt install  silversearcher-ag
"======================================================================
call plug#end()

" Notify Configure {
"弹窗美化 :lua vim.notify("This is an error message", "error")
if has("nvim")
  lua vim.notify = require("notify")
endif
" }

" Load lua config file {
if g:is_lua == 1
  let $MYLUARC = expand('$HOME/.config/nvim/yj.lua')
  luafile $MYLUARC
endif
" }

" Themes Configure {
set termguicolors
colorscheme seoul256
"colorscheme gruvbox
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
" TODO 用于给首次安装环境时 执行一些brew install 命令 <23-09-19 20:32:08, Yangdatong> 
"function! AskUser()
"    let answer = confirm("是否继续？ [Y/N] ")
"    if answer ==# 'Y' || answer ==# 'y'
"        echo "你选择了继续"
"    elseif answer ==# 'N' || answer ==# 'n'
"        echo "你选择了不继续"
"    else
"        echo "无效的输入"
"    endif
"endfunction

" Latex fast open Inkscape {
inoremap <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
"pip3 install inkscape-figures
" }

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
if g:is_lua == 1
  :command ConfigLua :e $MYLUARC
endif
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
if has('mac')
  map <C-h> :call IntoHeadrFile()<CR>
elseif has('linux')
  " TODO  <24-03-14 11:14:19, YangJing> "
  map <M-h> :call IntoHeadrFile()<CR>
endif
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
if has('mac')
  map <M-r> :call Run()<CR>
elseif has('linux')
  map <C-r> :call Run()<CR>
endif

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
    let firstLine = getline(1)
    if stridx(firstLine, '#manim') == 0
      let remainingChars = strpart(firstLine, strlen('#manim'))
      echo remainingChars
      exec '!manim ' remainingChars ' % Demo'
    else
      exec '!python3 %'
    endif
  elseif &filetype == 'manim'
    exec '!manim -pql % Demo'
  elseif &filetype == 'sh'
    :! bash %
  elseif &filetype == 'tex'
    normal \ll
  elseif &filetype == 'markdown'
    :MarkdownPreview
  endif
endfunc
" }

" Back to <gf> window buffers{
nnoremap gF <C-o> 
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  5. 自动执行命令区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Save mksession on vimleave {
if &filetype == 'cpp' || isdirectory(expand("%:p"))
  autocmd VimLeave * mksession!
endif
"}

" Mathematics file {
set background=dark
autocmd FileType tex colorscheme nord
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
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py,*.tex exec ":call SetTitle()"
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
  autocmd BufNewFile * normal G
endfunc
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  6. unite插件扩展区域                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"- `autocmd FileType unite call s:unite_my_settings()`：这行代码的意思是，当你打开的文件类型（FileType）是 unite 时，会自动调用 `s:unite_my_settings()` 这个函数。
"
"- `function! s:unite_my_settings()`：这是一个函数的定义，函数名为 `s:unite_my_settings`。这个函数中的代码主要是对 unite 插件的一些设置进行了自定义。
"
"- `imap <buffer> jj <Plug>(unite_insert_leave)`：这行代码的意思是，在插入模式（insert mode）下，当你在当前缓冲区（buffer）输入 `jj` 时，会触发 unite 插件的 `unite_insert_leave` 动作。
"
"- `imap <buffer><expr> j unite#smart_map('j', '')`：这行代码的意思是，在插入模式下，当你在当前缓冲区输入 `j` 时，会触发 unite 插件的 `smart_map` 动作。
"
"- `let g:deoplete#enable_at_startup = 1`：这行代码的意思是，当你启动 Vim 时，会自动启用 deoplete 插件。
"
"- `inoremap <expr><tab> pumvisible() ? "\<c-n>" :"\<tab>"`：这行代码的意思是，在插入模式下，当你输入 Tab 键时，如果弹出菜单（popup menu）是可见的，那么就会触发 `<C-n>` 动作，否则就会触发 `<Tab>` 动作。

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
