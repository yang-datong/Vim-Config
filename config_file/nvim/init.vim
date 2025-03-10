" CATALOGUE OUTLINE:
"0. 变量控制区域
"1. 基本配置区域
"2. 按键映射区域
"3. 插件配置区域
"4. 自定义命令、按键区域
"5. 自动执行命令区域
"6. unite插件扩展区域
"7. 后置命令与会话恢复区域



"Env -> {
  " 1. python3.10
  " 2. pip3.10
  " 3. brew(apt)
  " 4. iTerm2(Terminator)
" }

" Base Path{
let $NVIM_FOLDER=expand('$HOME/.config/nvim')
let $VIM_FOLDER=expand('$HOME/.vim')
" }

" Load funciton.vim {
" $HOME/.config/nvim/function.vim
source $NVIM_FOLDER/function.vim
" }



























"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     0. 变量控制区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:minimun_use=0
" Whether to enable plug-in(0->off | 1->on){
let g:is_latex=1  "Latex
let g:is_markdown=1  "Markdown
let g:is_lua=1  "Lua config
" }

" Whether to enable plug-in(0->off | 1->on){
let g:latex_full_compiled_mode=0 "1：开启vimtex 编译传入参数 0：不传入参数
let g:is_vim_studio=0 "1：用工程开发试图开发vim 0：普通vim编辑模式(已添加到脚本vimm中，不需要手动调整）
let g:is_Android_jni=0 "1：将添加Android-JNI头文件到path中，0：不添加
let g:is_inscape=1 "1：开启inkscape使用，0：不开启
" }

" Compatibility {
let g:is_nvim_notify=1
let g:is_coc_vim=1
" }

call CheckIsSetMinimunMode()

  " 如果文件大于3MB（3000000字节），在配置文件的最后会再次调用一次
call CheckISLargeFile(3000000)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     1. 基本配置区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File encoding {
set encoding=utf-8
set fencs=ucs-bom,utf-8,gbk,cp936,latin1
set formatoptions+=nM
" }

" Set include path -> use "gf" jump {
let g:python3_host_prog='/usr/local/bin/python3.10'
if has("mac")
  set path+=/Library/Developer/CommandLineTools/SDKs/MacOSX12.3.sdk/usr/include/c++/v1
elseif has('linux')
  set path+=/usr/lib/gcc/x86_64-linux-gnu/11/include
  set path+=/usr/include/x86_64-linux-gnu/c++/11
  set path+=/usr/include/x86_64-linux-gnu
  set path+=/usr/include/c++/11
  set path+=/usr/local/include
  set path+=/usr/include
  set path+=/usr/include/c++/11/backward
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
"set noshowcmd "在命令行不显示正在输入的命令。

if g:is_vim_studio == 1
  set number
  set laststatus=2
  "set statusline=file:[%<%f],\ funciton:[%{coc#status()}%{get(b:,'coc_current_function','')}()]\ %=\ [%P]
  set statusline=file:[%<%f],\ funciton:[%{get(b:,'coc_current_function','')}()]\ %=\ [%P]
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

if has("mac")
  " 开启鼠标支持,NOTE:
  " 复制时，需要开启insert模式，或者visual模式，这里只是添加了正常模式下的鼠标上下滚动支持
  set mouse=n
  " 但禁用鼠标左键点击切换光标位置
  noremap <LeftMouse> <Nop>
  noremap <2-LeftMouse> <Nop>
  noremap <3-LeftMouse> <Nop>
  noremap <4-LeftMouse> <Nop>

  " 但禁用鼠标拖动选择
  "noremap <LeftDrag> <Nop>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      2. 按键映射区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key-mapping {
" Abbreviations {
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
if g:is_vim_studio == 1
  cnoreabbrev wq wqall
  cnoreabbrev Wq wqall
  cnoreabbrev wQ wqall
  cnoreabbrev WQ wqall
else
  cnoreabbrev Wq wq
  cnoreabbrev wQ wq
  cnoreabbrev WQ wq
endif
cnoreabbrev Wa wa
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

" Window navigation in VIM-Terminal {
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
nnoremap <silent> <Leader>x :call ToggleHexMode()<CR>
" }

" Split {
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>
" }

" Tabs {
"切换窗口
"Ctrl + w + t 移动到第一个的窗口（模拟Chrome定位首个标签）
nnoremap <silent> <C-0> :wincmd t<CR>
nnoremap <silent> <A-0> :wincmd t<CR>
"Ctrl + w + b 移动到最后一个的窗口（模拟Chrome定位最后一个标签）
nnoremap <silent> <C-9> :wincmd b<CR>
nnoremap <silent> <A-9> :wincmd b<CR>

"第N个窗口（从左至右）
nnoremap <silent> <C-1> :1wincmd w<CR>
nnoremap <silent> <A-1> :1wincmd w<CR>
nnoremap <silent> <C-2> :2wincmd w<CR>
nnoremap <silent> <A-2> :2wincmd w<CR>
nnoremap <silent> <C-3> :3wincmd w<CR>
nnoremap <silent> <A-3> :3wincmd w<CR>

nnoremap <silent> <Tab> :wincmd w<CR>
nnoremap <silent> <S-Tab> :wincmd p<CR>
"nnoremap <Tab> gt
"nnoremap <S-Tab> gT
"nnoremap <silent> <S-t> :tabnew<CR>
" }

" Terminal { "在vim中打开terminal
nnoremap <silent> <Leader>t :botright split \| terminal<CR>i
:tnoremap <silent> <Esc> <C-\><C-n> :q<CR>
"exit 'terminal' mode
"}

" Set working directory {
nnoremap <Leader>. :lcd %:p:h<CR>
" }

" Buffer nav {
noremap <Leader>q :bp<CR>
noremap <Leader>w :bn<CR>
noremap <Leader>c :bd<CR>
"close buffer
" }

" Clean search (highlight) {
nnoremap <silent> <leader><space> :noh<cr>
" }

" fast show view in PDF {
if &filetype == 'tex' || &filetype == 'plaintex'
  nmap \v \lv
  nmap 'v \lv
endif
" }


" Switch Theme {
let g:current_theme = 'light' 
nnoremap <silent> <F5> :call ToggleTheme()<CR>
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      3. 插件配置区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugins {
if has("nvim")
  let s:vim_plug_dir=$NVIM_FOLDER . '/autoload'
else
  let s:vim_plug_dir=$VIM_FOLDER . '/autoload'
endif

if !filereadable(s:vim_plug_dir.'/plug.vim')
  exec '!wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -P '.s:vim_plug_dir
  let s:install_plug=1
endif

if has("nvim")
  call plug#begin( $NVIM_FOLDER . '/plugged')
else
  call plug#begin( $VIM_FOLDER . '/plugged')
endif
"======================================================================
"Plug 'dense-analysis/ale' "主要是用clang-tidy
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
Plug 'airblade/vim-gitgutter'  "配合git 左边栏显示更改、删除行标记
Plug 'chentoast/marks.nvim' "左边栏显示当前mark标记
"======================================================================
Plug 'tpope/vim-fugitive' "大名鼎鼎tpope开发的，在vim插件世界中，一直有着“TPope 出品，必属精品”的说法
noremap <Leader>gs :Git<CR>
"noremap <Leader>gb :Gblame<CR> "不知道怎么用
noremap <Leader>gd :Gvdiff<CR>
"很好用，再也不用使用cp new_file tmp && git restore new_file && vim -d new_file tmp了
"======================================================================
Plug 'sheerun/vim-polyglot' "语法高亮，代码缩进
"======================================================================
Plug 'vim-autoformat/vim-autoformat'
if (system('command -v clang-format') =~ 'clang-format') == 0
  call AskUserInstall("clang-format","default")
endif
if (system('command -v clangd') =~ 'clangd') == 0
  call AskUserInstall("clangd","default")
endif
"Python-格式化: pip install autopep8
"C\C++: 1.brew install clang-format 2.https://astyle.sourceforge.net 需要编译
"Java: apt install astyle
"Cmake : pip install cmake-format
"Markdown : npm install -g remark-cli
"Shell : apt install shfmt
if g:is_latex == 1
  "Must -> brew install latexindent
  if (system('command -v latexindent') =~ 'latexindent') == 0
    "call AskUserInstall("latexindent","default")
  endif
  let g:formatdef_latexindent = '"latexindent -"'  "设置Autoformat的格式化插件为latexindent
endif
"======================================================================
if g:is_coc_vim
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = ['coc-clangd','coc-snippets','coc-texlab','coc-sh','coc-cmake','coc-json','coc-pyright'] "自动安装Coc插件
"---More in lua config---
if g:is_latex == 1
  autocmd User CocJumpPlaceholderPre if !coc#rpc#ready() | silent! CocStart --channel-ignored | endif "Latex
  if has('mac')
    if (system('command -v texlab') =~ 'texlab') == 0
      echo "Please use -> brew install --HEAD texlab"
      "call AskUserInstall("texlab","default") #需要先安装mactex
    endif
  endif    "Must -> brew install --HEAD texlab
endif
endif
"======================================================================
Plug 'majutsushi/tagbar' "需要执行`:Tagbar`命令 可查看代码大纲
"let g:tagbar_position = 'vertical'
noremap <F2> :TagbarToggle <CR>
if (system('command -v ctags') =~ 'ctags') == 0
  if has('mac')
    call AskUserInstall("ctags","default")
  elseif has('linux')
    call AskUserInstall("universal-ctags","default")
  endif
endif
if g:is_vim_studio == 1
  autocmd VimEnter * nested :TagbarOpen<CR>
endif
let g:tagbar_sort= 0
"关闭函数等排序（默认会按照函数首字母来排序，不好定义源代码）
"Plug 'bronson/vim-trailing-whitespace' "加载这个插件会有冲突
"======================================================================
" Color thems
" Dark {
Plug 'junegunn/seoul256.vim'
Plug 'shaunsingh/nord.nvim' "Math style
"Plug 'doums/darcula'
Plug 'Mofiqul/vscode.nvim'
"Plug 'dylanaraps/wal'
"Plug 'morhetz/gruvbox'
" }
" Light {
Plug 'nyoom-engineering/oxocarbon.nvim'
" }
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
  Plug 'lervag/vimtex', { 'tag': 'v2.14' }
  let g:vimtex_quickfix_mode=0
  let g:tex_flavor = 'latex'
  if has('mac')
    " Use Skim (Skim的字体展示会比较黑,但是zathura配置很麻烦）
    let g:vimtex_view_general_viewer = 'skim'
    let g:vimtex_view_method = 'skim'
    "在skim中-同步：
    "预设：自定义
    "命令：nvim
    "参数：--headless -c "VimtexInverseSearch %line '%file'"
    "某些路径(或中文)会有问题导致使用正向定位会失效（绝对路径）
  elseif has('linux')
    " Use zathura
    let g:vimtex_view_general_viewer = 'zathura'
    let g:vimtex_view_method='zathura'
  endif
  " 是否转移焦点到PDF预览器中
  "let g:vimtex_view_skim_sync = 1
  "let g:vimtex_view_skim_activate = 1
  "let g:vimtex_view_general_options = '-r @line @pdf @tex'

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

        "\   '-outdir=build',
        "\   '-auxdir=build',
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
  let g:tex_conceal_frac=1
  let g:tex_superscripts= "[0-9a-zA-W.,:;+-<>/()=]"
  let g:tex_subscripts= "[0-9aehijklmnoprstuvx,+-/().]"
  set conceallevel=2
  let g:tex_conceal='abdmg'
  hi Conceal ctermbg=none
endif
"======================================================================
if g:is_markdown == 1
  autocmd FileType math set filetype=markdown
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  autocmd FileType math set filetype=tex
  let g:mkdp_theme ='dark'
  if has('mac')
    let g:mkdp_browser = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    "let g:mkdp_browser = '/Applications/Firefox.app/Contents/MacOS/firefox'
    "let g:mkdp_browser = '/Applications/Firefox.app/Contents/MacOS/Safari'
  else
    let g:mkdp_browser = '/usr/bin/google-chrome-stable'
  endif
endif
"======================================================================
Plug 'scrooloose/nerdtree'
" NERDTree {
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite,.git
let g:NERDTreeChDirMode=2
let NERDTreeShowHidden=1
let g:NERDTreeIgnore=['.out$','.cmake$','.vim$','.git','CMakeCache.txt','CMakeFiles','__pycache__']
"let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize=30
"nnoremap <silent> <Leader>l :NERDTreeFind<CR>
noremap <F1> :NERDTreeToggle<CR>
" Close NERDTree if no other window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
if g:is_vim_studio == 1
  autocmd VimEnter * nested :NERDTreeToggle
endif
" }
"======================================================================
Plug 'preservim/nerdcommenter'  "注释插件（'n' 为正常模式下的触发，'x'为选中默认下的触发）
" Multiple trigger {
noremap <silent> <leader>/ :call nerdcommenter#Comment('n', 'toggle')<CR> :execute 'normal 0 j'<CR>
vnoremap <silent> <leader>/ :call nerdcommenter#Comment('x', 'invert')<CR>
"noremap <silent> <leader>c :call nerdcommenter#Comment('n', 'toggle')<CR>
"vnoremap <silent> <leader>c :call nerdcommenter#Comment('x', 'invert')<CR>
"使用这个快捷键会有1秒左右的延迟
if has('mac')
  "在iterm2 的key Bindings:
  "1. Keyboard Shortcut: Command + /
  "2. Action: Send Text with 'vim' Special Chars
  "3. :call nerdcommenter#Comment('n', 'invert') | exec "normal 0 j" \n
elseif has('linux')
  noremap <silent> <C-_> :call nerdcommenter#Comment('n', 'toggle')<CR>:execute 'normal 0 j'<CR>
  vnoremap <silent> <C-_> :call nerdcommenter#Comment('x', 'invert')<CR>:execute 'normal 0 j'<CR>
endif
" }
"======================================================================
if has("nvim") && g:is_nvim_notify == 1
  Plug 'rcarriga/nvim-notify'
endif
"======================================================================
Plug 'deris/vim-shot-f' "高亮f/F,t/T命令
"======================================================================
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim' "主要是使用 Files查找文件，以及Ag查找字符
"nvim-telescope/telescope.nvim 也具有类似功能
"Ag功能需要额外安装：
"Plug 'BurntSushi/ripgrep' "Rg 官网描述是比Ag更快
if (system('command -v fzf') =~ 'fzf') == 0
  call AskUserInstall("fzf","default")
endif
if (system('command -v ag') =~ 'ag') == 0
  if has('mac')
    call AskUserInstall("the_silver_searcher","default")
  elseif has('linux')
    call AskUserInstall("silversearcher-ag","default")
  endif
endif

"Plug 'rking/ag.vim' "界面不好看
"======================================================================
"Plug 'nvim-tree/nvim-tree.lua' "和NERDTreeToggle差不多
"Plug 'nvim-tree/nvim-web-devicons'
"======================================================================
"重新排序选项卡
"Plug 'nvim-tree/nvim-web-devicons' " OPTIONAL: for file icons
"Plug 'lewis6991/gitsigns.nvim' " OPTIONAL: for git status
"Plug 'romgrk/barbar.nvim'
"======================================================================
"重新排序选项卡
"Plug 'nvim-tree/nvim-web-devicons' " Recommended (for coloured icons)
 "Plug 'ryanoasis/vim-devicons' Icons without colours
"Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
"======================================================================
"自动保存写入
Plug '907th/vim-auto-save'
let b:auto_save = 0
if &filetype == 'tex' || &filetype == 'plaintex'
  augroup ft_tex
    au!
    au FileType tex let b:auto_save = 1 "对于Latex时，自动执行保存文件
  augroup END
endif
"======================================================================
if &filetype != 'tex' && &filetype != 'plaintex'
  Plug 'github/copilot.vim'
endif
"======================================================================
call plug#end()
" }

"" Load lua config file {
if g:is_lua == 1
  let $MYLUARC = $NVIM_FOLDER . '/yj.lua'
  luafile $MYLUARC

  if has("nvim") && g:is_nvim_notify == 1
    lua vim.notify = require("notify")
    "弹窗美化 :lua vim.notify("This is an error message", "error")
  endif
endif
"" }

" Themes Configure {
set termguicolors
" Dark
colorscheme seoul256
"colorscheme darcula
"colorscheme vscode
"colorscheme gruvbox
"colorscheme nord
" Light
"colorscheme oxocarbon
" }

" Unite Configure {
call unite#filters#matcher_default#use(['matcher_fuzzy'])
nnoremap <Leader>f :<C-u>Unite file_rec/neovim<CR>
"nnoremap <Leader>e :<C-u>Unite -no-split -buffer-name=mru file_mru<cr>
"nnoremap <Leader>b :<C-u>Unite -quick-match buffer<cr>
"nnoremap <Leader>r :<C-u>Unite -no-split -buffer-name=register register<CR>
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
" 选中单词 ag 搜索 {
nnoremap <C-F> :Ag <C-R><C-W><CR>
vnoremap <C-F> "xy :<C-u>Ag <C-r>x<CR>
" }

" ZH translate to en {
"inoremap <silent> <C-e> <Esc>: silent exec "r !trans :en " . getline('.') . " -b -e bing "<CR>
"nnoremap <silent> <C-e> <Esc>: silent exec "r !trans :en " . getline('.') . " -b -e bing "<CR>
if (system('command -v trans') =~ 'trans') == 0
  call AskUserInstall("translate-shell","default")
endif
" }

" Open current gdb window {
if &filetype == 'cpp' || &filetype == 'c' ||  &filetype == 'hpp' ||  &filetype == 'h' || g:is_vim_studio == 1
  :command Gdb call OpenWindowIntoGDB(0)
  :command GDB call OpenWindowIntoGDB(0)
  :command GDBS call OpenWindowIntoGDB(1)
  nnoremap <silent> <Leader>gdb :call OpenWindowIntoGDB(0)<CR>
endif
nnoremap <C-G> :GDB<CR>
"}

" Back to <gf> window buffers {
nnoremap gF <C-o>
" }

" Latex fast open Inkscape {
if g:is_inscape == 1
inoremap <silent> <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
if (system('command -v inkscape-figures') =~ 'inkscape-figures') == 0
  call AskUserInstall("inkscape-figures","pip3.10")
endif
endif
" }

" Check current line end char is ";" {
if &filetype == 'cpp' || &filetype == 'c' ||  &filetype == 'hpp' ||  &filetype == 'h' || g:is_vim_studio == 1
  if has('mac')
    inoremap <expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-o>A<Esc>o" : "\<C-o>A;<Esc>o"
  elseif has('linux')
    inoremap <expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-Enter>" : "\<C-o>A;<Esc>o"
  endif
endif
" }

" Fast open configure file {
:command Config :e $MYVIMRC
:command Configfun :e $NVIM_FOLDER/function.vim
if g:is_lua == 1
  :command ConfigLua :e $MYLUARC
endif
" }

" Command {  "auto merge text to one line
:command -range=% Line :<line1>,<line2>s/\n/ /g | noh
" }

" Command {  "Expand t-o-d-o list
":command TODO :vimgrep /TODO/gj **/* | botright copen
:command TODO :Ag TODO
  "vimgrep 是 Vim 的内置命令，用于在文件中搜索指定的模式。
  "/t-o-d-o/ 是要搜索的模式，即 “t-o-d-o” 字符串。
  ""g 表示全局搜索，即搜索整个文件。
  "j 表示 “jump”，即在搜索完成后不跳转到第一个匹配的位置。
  "% 表示当前文件。
  "botright：窗口在最后一个窗口的底部弹出（多窗口时）
  "copen：这个命令打开一个新窗口显示所有的搜索结果
" }

" Fast into head or source file {
if &filetype == 'cpp' || &filetype == 'c' ||  &filetype == 'hpp' ||  &filetype == 'h' || g:is_vim_studio == 1
  "(手动实现）
  "map <silent> <S-h> :call IntoHeadrOrSourceFile()<CR>
  "(coc-clangd实现)
  map <silent> <S-h> :CocCommand clangd.switchSourceHeader <CR> 
  "分割缓冲区中打开 
  map <silent> <S-l> :CocCommand clangd.switchSourceHeader vsplit <CR> 
endif
" }

" Fast start file execution {
if has('mac')
  "在iTerm2 的key Bindings:
  "1. Keyboard Shortcut: Command + r
  "2. Action: Send Text with 'vim' Special Chars
  "3. :call Run()\n
elseif has('linux')
  map <C-r> :call Run()<CR>
endif
" }

" 在h264 h265文件中查找Nalu startCode
command! FindNaluStartCode /0000 01\|00 0001\|0000 0001\|0000 01


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  5. 自动执行命令区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto open by hex model {
autocmd BufReadPre *.{bin,jpg,jpeg,JPG,JPEG,h264,h265,avc,hevc,yuv,rgb,ppm,bmp,out} setlocal binary
autocmd BufReadPost *.{bin,jpg,jpeg,JPG,JPEG,h264,h265,avc,hevc,yuv,rgb,ppm,bmp,out} call ToggleHexMode()
" }


" 打开文件时自动调用检查函数（检查文件行数如果小于1000行，则在写入指定格式文件时自动格式化，以及在某些特定格式模版下，不需要进行格式化，比如小窗口的vim-tex，固定为3行，且不需要格式化）{
au! BufNewFile,BufRead *.tpp set filetype=cpp
autocmd FileType c,cpp,tex,sh autocmd BufWritePre <buffer> call AutoformatIfSmall(1000,3)
" }

" Save mksession on vimleave {
if g:is_vim_studio == 1
  autocmd VimLeave * mksession!
endif
"}

" Mathematics file {
"set background=dark
"autocmd FileType tex colorscheme nord
"autocmd FileType math colorscheme nord
autocmd FileType math UltiSnipsAddFiletypes markdown.snippets
autocmd FileType math set filetype=tex

autocmd FileType manim UltiSnipsAddFiletypes python.snippets
autocmd FileType manim set filetype=python
" }

" Restore to the position where it was last closed {
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }

" Auto add Executive authority{
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent exec "!chmod +x <afile>" | endif | endif
" }

" Auto add File Content{
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py exec ":call SetTitle()"
" }

" Auto Lines to log{
autocmd BufReadPost *.log exec ":set nu"
" }

" 在保存文件时根据hexmode状态是否切回二进制形态进行写入文件
autocmd BufWritePre * if &filetype == "xxd" | call ToggleHexMode() | endif


" 在保存文件时根据使用notify通知当前警告和错误
if has("nvim") && g:is_nvim_notify == 1
  if &filetype != 'plaintex'
    autocmd BufWritePre * call DiagnosticNotify()
  endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  6. unite插件扩展区域                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $NVIM_FOLDER/unite_extension.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  7. 后置命令与会话恢复区域                        "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 如果文件大于3MB（3000000字节）
call CheckISLargeFile(3000000)


if g:is_vim_studio == 1
  "autocmd VimEnter * echo "Total windows: " . winnr('$') . ", Current window: " . winnr()  
  autocmd VimEnter * if winnr('$') == 3 | exe "2wincmd w" | endif
endif
