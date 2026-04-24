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
" 1. python3
" 2. pip3
" 3. brew(apt)
" 4. iTerm2(Terminator)
" }

" Base Path{
let $NVIM_FOLDER=expand('$HOME/.config/nvim')
let $VIM_FOLDER=expand('$HOME/.vim')
let $MYLUARC = $NVIM_FOLDER . '/yj.lua'
let $LUA_LAZY = $NVIM_FOLDER . '/lua/lazy.lua'
let $LUA_LAZY_PLUG = $NVIM_FOLDER . '/lua/plugins.lua'
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
if !has("nvim")
  let g:is_lua=0
endif
" }

" Whether to enable plug-in(0->off | 1->on){
let g:latex_full_compiled_mode=1 "1：开启vimtex 编译传入参数 0：不传入参数
let g:is_vim_studio=0 "1：用工程开发试图开发vim 0：普通vim编辑模式(已添加到脚本vimm中，不需要手动调整）
let g:is_Android_jni=0 "1：将添加Android-JNI头文件到path中，0：不添加
let g:is_inscape=1 "1：开启inkscape使用，0：不开启
let g:is_ask=1 "1：开启环境依赖安装询问
" }

" Compatibility {
let g:is_nvim_notify=1
let g:is_coc_vim=1
" }

" 在 Docker 容器中，关闭notify
if filereadable('/.dockerenv')
  let g:is_nvim_notify=0
endif

call CheckIsSetMinimunMode()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     1. 基本配置区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File encoding {
set encoding=utf-8
set fencs=ucs-bom,utf-8,gbk,cp936,latin1
set formatoptions+=nM
" }

" Set include path -> use "gf" jump {
"if has("mac") || has('linux')
  "let g:python3_host_prog='/usr/local/bin/python3.10'
"endif
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
    set path+=expand('$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64/sysroot/usr/include')
  elseif has('linux')
    set path+=expand('$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/include')
  endif
endif
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
if g:is_vim_studio == 1
  cnoreabbrev q qall
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
  nnoremap <silent> <A-1> :1wincmd w<CR>
  nnoremap <silent> <A-2> :2wincmd w<CR>
  nnoremap <silent> <A-3> :3wincmd w<CR>
endif

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

" Switch Theme {
let g:current_theme = 'light'
nnoremap <silent> <F5> :call ToggleTheme()<CR>
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      3. 插件配置区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" Plugins {
if has("nvim")
  luafile $LUA_LAZY
else
  echom 'lazy.nvim 仅支持 Neovim，已跳过插件加载'
endif
" 环境依赖检查（插件配置本身已迁移到 lua/plugins.lua）
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
"Asm : brew intall asmfmt
if g:is_latex == 1
  "Must -> brew install latexindent
  if has('mac')
    if (system('command -v latexindent') =~ 'latexindent') == 0
      call AskUserInstall("latexindent","default")
    endif
  endif
  "NOTE: 在Apple silicon中安装的/Library/TeX/texbin/latexindent有问题，需要手动通过brew install latexindent安装，同时还需要去掉高优先路径的执行权限：
  "$ chmod -x /Library/TeX/texbin/latexindent
  "NOTE: Ubuntu在安装的texlive是可以直接使用的
endif
"Arm64-gas use -> https://github.com/klauspost/asmfmt
"x86-64-nasm use -> wget https://github.com/yamnikov-oleg/nasmfmt/releases/download/v0.1/nasmfmt_linux64.tar.gz
"======================================================================
"let g:tagbar_position = 'vertical'
if (system('command -v ctags') =~ 'ctags') == 0
  if has('mac')
    call AskUserInstall("ctags","default")
  elseif has('linux')
    call AskUserInstall("universal-ctags","default")
  endif
endif

"nvim-telescope/telescope.nvim 也具有类似功能
"Ag功能需要额外安装：
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

" 自定义文件类型识别
source $NVIM_FOLDER/filetype.vim
" }

"" Load lua config file {
if g:is_lua == 1
  luafile $MYLUARC
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
command! Gdb call OpenWindowIntoGDB(0)
command! GDB call OpenVimWindowIntoGDB(0)
command! GDBS call OpenWindowIntoGDB(1)
nnoremap <silent> <Leader>gdb :call OpenWindowIntoGDB(0)<CR>
nnoremap <C-G> :GDB<CR>
"}

" Back to <gf> window buffers {
"nnoremap gF <C-o>
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
augroup ft_c_semicolon
  autocmd!
  if has('mac')
    autocmd FileType c,cpp,h,hpp inoremap <buffer><expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-o>A<Esc>o" : "\<C-o>A;<Esc>o"
  elseif has('linux')
    autocmd FileType c,cpp,h,hpp inoremap <buffer><expr> <C-Enter> getline('.')[-1:] == ';' ? "\<C-Enter>" : "\<C-o>A;<Esc>o"
  endif
augroup END
" }

" Fast open configure file {
:command Config :e $MYVIMRC
:command Configfun :e $NVIM_FOLDER/function.vim
if g:is_lua == 1
  :command ConfigLua :e $MYLUARC
  :command ConfigPlug :e $LUA_LAZY_PLUG
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
augroup ft_c_switch_header
  autocmd!
  " (手动实现）
  " autocmd FileType c,cpp,h,hpp nnoremap <buffer><silent> <S-h> :call IntoHeadrOrSourceFile()<CR>
  " (coc-clangd实现)
  autocmd FileType c,cpp,h,hpp nnoremap <buffer><silent> <S-h> :CocCommand clangd.switchSourceHeader<CR>
  " 分割缓冲区中打开
  autocmd FileType c,cpp,h,hpp nnoremap <buffer><silent> <S-l> :CocCommand clangd.switchSourceHeader vsplit<CR>
augroup END
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

" 大文件模式检查
augroup large_file_mode
  autocmd!
  autocmd BufReadPre * call CheckISLargeFile(3000000)
augroup END


" 打开文件时自动调用检查函数（检查文件行数如果小于1000行，则在写入指定格式文件时自动格式化，以及在某些特定格式模版下，不需要进行格式化，比如小窗口的vim-tex，固定为3行，且不需要格式化）{
autocmd BufNewFile,BufRead *.tpp set filetype=cpp
"autocmd FileType c,cpp,tex,sh autocmd BufWritePre <buffer> call AutoformatIfSmall(1000,3)
"NOTE:关掉了latex的format，在实时编辑的时候太卡顿了
autocmd FileType sh autocmd BufWritePre <buffer> call AutoformatIfSmall(1000,3)
" }

" Save mksession on vimleave {
"if g:is_vim_studio == 1
"autocmd VimLeave * mksession!
"endif
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

" Assembler file {
" for x86.asm use nasm
"autocmd FileType asm set filetype=nasm
" for arm.s use gas
"autocmd FileType arm set filetype=asm
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
  autocmd BufWritePre * if &filetype !=# 'plaintex' | call DiagnosticNotify() | endif
endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  6. unite插件扩展区域                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source $NVIM_FOLDER/unite_extension.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  7. 后置命令与会话恢复区域                        "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 在 Visual 模式下创建映射，按下 <C-h> (Ctrl+h) 时调用函数 {
highlight SimilarRegsHighlight ctermbg=DarkCyan guibg=DarkCyan ctermfg=white guifg=white
vnoremap <C-h> <Cmd>call HighlightSimilarRegisters()<CR>
" }
