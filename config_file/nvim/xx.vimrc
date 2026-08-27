" CATALOGUE OUTLINE:
"0. 变量控制区域
"1. 基本配置区域
"2. 按键映射区域
"3. 插件配置区域
"4. 自定义命令、按键区域
"5. 自动执行命令区域
"6. unite插件扩展区域
"7. 后置命令与会话恢复区域































"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     0. 变量控制区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     1. 基本配置区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File encoding {
set encoding=utf-8
set fencs=ucs-bom,utf-8,gbk,cp936,latin1
set formatoptions+=nM
" }

" Attribute {
"共享剪贴板
if has("mac")
  set clipboard=unnamed  
elseif has('linux')
  set clipboard=unnamedplus
elseif has('win32')
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
"按照缩进折叠
set foldmethod=indent
"按照语法折叠
"set foldmethod=syntax
set foldlevel=2
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
" }

" Close the pop-up window {
" 影响主要是在编写代码时会弹出函数定义框，需要手动关闭影响布局
"set completeopt-=preview
" }
""}

"if has("mac")
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
"endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      2. 按键映射区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Key-mapping {
" Abbreviations {
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev wQ wq
cnoreabbrev WQ wq
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
if has('mac')
  "nnoremap <silent> <C-0> :wincmd t<CR>
  "nnoremap <silent> <C-9> :wincmd b<CR>
  "在iTerm2 的key Bindings:
  "1. Keyboard Shortcut: Option + 0
  "2. Action: Send Text with 'vim' Special Chars
  "3. :wincmd t\n
elseif has('linux')
  "Ctrl + w + t 移动到第一个的窗口（模拟Chrome定位首个标签）
  nnoremap <silent> <C-0> :wincmd t<CR>
  "Ctrl + w + b 移动到最后一个的窗口（模拟Chrome定位最后一个标签）
  nnoremap <silent> <C-9> :wincmd b<CR>
endif


"第N个窗口（从左至右）
if has('mac')
  "nnoremap <silent> <C-1> :1wincmd w<CR>
  "nnoremap <silent> <C-2> :2wincmd w<CR>
  "nnoremap <silent> <C-3> :3wincmd w<CR>
  "在iTerm2 的key Bindings:
  "1. Keyboard Shortcut: Option + 1
  "2. Action: Send Text with 'vim' Special Chars
  "3. :1wincmd w\n
elseif has('linux')
  nnoremap <silent> <C-1> :1wincmd w<CR>
  nnoremap <silent> <C-2> :2wincmd w<CR>
  nnoremap <silent> <C-3> :3wincmd w<CR>
endif

"nnoremap <silent> <A-1> :1wincmd w<CR>
"nnoremap <silent> <A-2> :2wincmd w<CR>
"nnoremap <silent> <A-3> :3wincmd w<CR>

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

" Themes Configure {
set termguicolors
" Dark
"colorscheme seoul256
"colorscheme darcula
"colorscheme vscode
"colorscheme gruvbox
"colorscheme nord
" Light
"colorscheme oxocarbon
" }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  4. 自定义命令、按键区域                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Check current line end char is ";" {
if &filetype == 'cpp' || &filetype == 'c' ||  &filetype == 'hpp' ||  &filetype == 'h'
  if has('mac')
    inoremap <expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-o>A<Esc>o" : "\<C-o>A;<Esc>o"
  elseif has('linux')
    inoremap <expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-Enter>" : "\<C-o>A;<Esc>o"
  endif
endif
" }

" Fast open configure file {
:command Config :e $MYVIMRC
" }

" Command {  "auto merge text to one line
:command -range=% Line :<line1>,<line2>s/\n/ /g | noh
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


" Assembler file {
au BufNewFile,BufRead *.s set filetype=asm
au BufNewFile,BufRead *.S set filetype=asm
" }

" Restore to the position where it was last closed {
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }

" Auto add Executive authority{
au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent exec "!chmod +x <afile>" | endif | endif
" }

" Auto Lines to log{
autocmd BufReadPost *.log exec ":set nu"
" }
