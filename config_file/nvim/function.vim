" CATALOGUE OUTLINE:
"0. 变量控制区域
"1. 基本配置区域
"2. 按键映射区域
"3. 插件配置区域
"4. 自定义命令、按键区域
"5. 自动执行命令区域
"6. Coc-nvim 区域


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     0. 变量控制区域                               "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func CheckIsSetMinimunMode()
  if g:minimun_use == 1
    let g:is_latex=0
    let g:is_markdown=0
    let g:is_lua=0
    let g:latex_full_compiled_mode=0
    let g:is_vim_studio=0
    let g:is_Android_jni=0
    let g:is_nvim_notify=0
    let g:is_coc_vim=0
    let g:is_inscape=0
  endif
endfunc


func CheckISLargeFile(maxSize)
  if getfsize(expand("%:p")) > a:maxSize
    " 关闭语法高亮
    syntax off
    " 关闭文件类型检测
    filetype off
    " 设置其他性能优化选项……
    set lazyredraw
    set nowrap
    set noswapfile
    set nobackup
    set nowritebackup
    let g:minimun_use=1
    echo "[Leader File Model]"
    " 大于1G
    if getfsize(expand("%:p")) > 100000000
      let g:minimun_use = 1
      call CheckIsSetMinimunMode()
    endif
  endif
endfunc

func CheckFileLineCount(maxLine)
  if line('$') < a:maxLine "文件小于x行才自动格式化
    autocmd FileType c autocmd BufWritePre <buffer> Autoformat
    autocmd FileType cpp autocmd BufWritePre <buffer> Autoformat
    autocmd FileType tex autocmd BufWritePre <buffer> Autoformat
    autocmd FileType sh autocmd BufWritePre <buffer> Autoformat
    au! BufNewFile,BufRead *.tpp set filetype=cpp
  endif
endfunc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      2. 按键映射区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Call shell to install command tools {
func AskUserInstall(cmd,packager)
  let answer = confirm("Whether to install " . a:cmd . "?")
  if answer ==# '1' "Exc键为0,Enter键为1（期间不管你输入了什么键）
    if a:packager == 'default' "传入default则表示系统默认包管理器
      if has('mac')
        exec '!brew install ' . a:cmd
      elseif has('linux')
        echo "Please use: 'sudo apt install " . a:cmd . "', will into the vim-terminal , Are you ready?"
        "exec '!sudo apt install ' . a:cmd "不能直接输入密码
        exec ':terminal sudo apt install -y ' . a:cmd
        startinsert "进入vim输入模式
      endif
    elseif a:packager == 'pip3.10'
      exec '!pip3.10 install ' . a:cmd
    endif
  endif
endfunc
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  4. 自定义命令、按键区域                          "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Hex model edit{
function! ToggleHexMode()
  " 对于非文本类型的文件&filetype会为空，则开启转换十六进制模式
  if &filetype == "" || &filetype == "xxd"
    if exists('b:hexmode') && b:hexmode
      " 如果已经在十六进制模式下，则关闭它
      %!xxd -r
      set filetype=
      let b:hexmode = 0
    else
      %!xxd
      set filetype=xxd
      let b:hexmode = 1
    endif
  endif
endfunction
" }

" For mutable GDB points
func GetAllMarks()
    let marks = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
    let mark_lines = []

    for mark in marks
        let lnum = line("'" . mark)
        if lnum > 0
            call add(mark_lines, {'mark': mark, 'line': lnum})
        endif
    endfor
    return mark_lines
endfunction

" Need install iTerm2 or terminator
func OpenWindowIntoGDB()
  let gdb_file = ''
  for file in [expand('%:t:r'), "./build/" . expand('%:t:r'), "a.out", "./build/a.out", "./ffmpeg_g"]
    if filereadable(file)
      let gdb_file = file
      break
    endif
  endfor

  if gdb_file == ''
    echo "Not found the executable file"
    return -1
  endif

  let cwd = expand('%:p:h')
  if has('mac')
    let gdb_cmd= printf("!osascript -e 'tell application \"iTerm2\" to set newWindow to (create window with default profile)' -e 'tell application \"System Events\" to keystroke \"cd %s && gdb %s -o \\\"b %s:%d\\\" -o \\\"r\\\" \" & return & delay 0.1 & key code 36'", cwd, gdb_file, expand('%:t'), line('.'))
  elseif has('Linux')
    let gdb_cmd = filereadable("./gdb.sh") ? printf("!terminator -x fish -c 'pwd && ./gdb.sh \"b %s:%d\"; exec fish'", expand('%'), line('.')) : printf("!terminator -x fish -c 'pwd && gdb %s -ex \"b %s:%d\"; exec fish'", gdb_file, expand('%'), line('.'))
  endif
  "echo gdb_cmd
  silent exec gdb_cmd
endfunc
" }


" Show all snippets command {
" Public Interface for tex.snippets
func GetAllSnippets()
  call UltiSnips#SnippetsInCurrentScope(1)
  let list = []
  for [key, info] in items(g:current_ulti_dict_info)
    call add(list, key)
  endfor
  return list
endfunc
"}


" Fast into head/source file {
func TryFindHeadfile(name)
  if filereadable(name . '.hpp')
    return ".hpp"
  elseif filereadable(name . '.h')
    return ".h"
  else
    return ""
endfunc

func FindAndEditHeaderFile(filename,filetype)
  " 定义要搜索的目录数组
  let directories = ['.', 'include', 'inc', '../include', '../inc']

  " 遍历目录数组
  for directory in directories
    " 检查目录中是否包含 .h 或 .hpp 文件
    let c_head = directory . '/' .  a:filename  .'.h'
    let cpp_head = directory . '/' .  a:filename  .'.hpp'
    if filereadable(cpp_head) "优先hpp
      execute "e " . cpp_head
      return
    elseif filereadable(c_head)
      execute "e " . c_head
      return
    endif
  endfor
  " 如果没有找到文件，则在当前目录创建一个
  if a:filetype == 'cpp'
    let filetype = '.hpp'
  elseif a:filetype == 'c'
    let filetype = '.h'
  endif

  execute "e " . a:filename . filetype
  echo "New create: " . a:filename . filetype
endfunc

func FindAndEditSourceFile(filename,filetype)
  " 定义要搜索的目录数组
  let directories = ['.', '..', 'src', 'source', '../src', '../source']
  " 遍历目录数组
  for directory in directories
    " 检查目录中是否包含 .h 或 .hpp 文件
    let c_src = directory . '/' .  a:filename  .'.c'
    let cpp_src = directory . '/' .  a:filename  .'.cpp'
    if filereadable(cpp_src) "优先cpp
      execute "e " . cpp_src
      return
    elseif filereadable(c_src)
      execute "e " . c_src
      return
    endif
  endfor
  " 如果没有找到文件，则在当前目录创建一个
  if a:filetype == 'hpp'
    let filetype = '.cpp'
  elseif a:filetype == 'h'
    let filetype = '.c'
  endif

  execute "e " . a:filename . filetype
  echo "New create: " . a:filename . filetype
endfunc

func IntoHeadrOrSourceFile()
  let filename = expand('%:t:r')
  let filetype = expand('%:e')
  if filename == 'main'
    return
  endif
  if filetype == 'cpp' || filetype == 'c'
    call FindAndEditHeaderFile(filename,filetype)
  elseif filetype == 'hpp' || filetype == 'h'
    call FindAndEditSourceFile(filename,filetype)
  endif
endfunc
" }


" Fast start file execution {
func Run()
  exec "w"
  let filetype = &filetype
  let exec_cmd = ''

  if filetype == 'c' || filetype == 'cpp'
    let compiler = filetype == 'c' ? 'gcc' : 'g++'
    let make_cmd = "make -j4 && if [ -f a.out ]; then ./a.out; fi"
    let make2_cmd = "make -C build -j4 && if [ -f build/a.out ]; then ./build/a.out; fi"
    let build_cmd = "cmake -B build . && cmake --build build -j4 && if [ -f ./build/a.out ]; then ./build/a.out; fi"

    if filereadable('Makefile')
      let exec_cmd = "!bash -c '" . make_cmd . "'"
    elseif filereadable('./build/Makefile')
      let exec_cmd = "!bash -c '" . make2_cmd . "'"
    elseif filereadable('CMakeLists.txt')
      let exec_cmd = "!bash -c '" . build_cmd . "'"
    else
      let firstLine = getline(1)
      let remainingChars = stridx(firstLine, filetype == 'c' ? '// gcc' : '// g++') == 0 ? strpart(firstLine, strlen(filetype == 'c' ? '// gcc' : '// g++')) : ''
      let exec_cmd = printf("!%s %% -o %%< -g3 -O0 -Wall -std=%s %s", compiler, filetype == 'c' ? 'c17' : 'c++14', remainingChars)
      exec exec_cmd . ' && ./%<'
      return 0
    endif
  elseif filetype == 'python'
    let firstLine = getline(1)
    let remainingChars = stridx(firstLine, '#manim') == 0 ? strpart(firstLine, strlen('#manim')) : ''
    let exec_cmd = remainingChars != '' ? '!manim ' . remainingChars . ' % Demo' : '!python3 %'
  elseif &filetype == 'sh'
    :! bash %
  elseif &filetype == 'tex'
    "Vimtex
    normal \ll 
  elseif &filetype == 'markdown'
    :MarkdownPreview
  endif

  if exec_cmd != ''
    exec exec_cmd
  endif
endfunc
" }


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  5. 自动执行命令区域                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto add File Content{
func SetTitle()
  if &filetype == 'sh'
    call setline(1, "#!/bin/bash")
  endif
  if &filetype == 'cpp'
    call setline(1, "#include <iostream>")
  endif
  if &filetype == 'c'
    call setline(1, "#include <stdio.h>")
  endif
  if &filetype == 'python'
    if has("mac")
      call setline(1, "#!/usr/local/bin/python3.10")
    elseif has('linux')
      call setline(1, "#!/usr/bin/python3.10")
    endif
  endif
  call setline(2,"")
  normal G
endfunc
" }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                  6. Coc-nvim 区域                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func DiagnosticNotify() abort
  let l:info = get(b:, 'coc_diagnostic_info', {})
  if empty(l:info) | return '' | endif
  let l:msgs = []
  let l:level = 'info'
   if get(l:info, 'warning', 0)
    let l:level = 'warn'
  endif
  if get(l:info, 'error', 0)
    let l:level = 'error'
  endif
 
  if get(l:info, 'error', 0)
    call add(l:msgs, 'Errors: ' . l:info['error'])
  endif
  if get(l:info, 'warning', 0)
    call add(l:msgs, 'Warnings: ' . l:info['warning'])
  endif
  if get(l:info, 'information', 0)
    call add(l:msgs, 'Infos: ' . l:info['information'])
  endif
  if get(l:info, 'hint', 0)
    call add(l:msgs, 'Hints: ' . l:info['hint'])
  endif
  let l:msg = join(l:msgs, "\n")
  "if empty(l:msg) | let l:msg = ' All OK' | endif
  if empty(l:msg) | return 0 | endif
  call v:lua.coc_diag_notify(l:msg, l:level)
endfunc
