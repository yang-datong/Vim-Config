" CATALOGUE OUTLINE:
"0. 变量控制区域
"1. 基本配置区域
"2. 按键映射区域
"3. 插件配置区域
"4. 自定义命令、按键区域
"5. 自动执行命令区域
"6. unite插件扩展区域


"README: 这个文件全都是从init.vim中提取出来的函数


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
  if filereadable(expand('%:t:r'))
    let gdb_file = expand('%:t:r')
  elseif filereadable("a.out")
    let gdb_file = "a.out"
  else
    echo "Not fond the executable file"
  endif
  let cwd = expand('%:p:h')
  if has('mac')
    silent exec "!osascript -e 'tell application \"iTerm2\" to set newWindow to (create window with default profile)' -e 'tell application \"System Events\" to keystroke \"cd " . cwd .  " && gdb " . gdb_file . " -o \\\"b " . expand('%:t') . ":" . line('.') . "\\\" \" & return & delay 0.1 & key code 36'"
  elseif has('Linux')
    let gdb_cmd = printf("!terminator -x fish -c 'pwd && gdb %s -ex \"b %s:%d\"; exec fish'",gdb_file,expand('%:t'),line('.'))
  endif
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
  if &filetype == 'c'
    let firstLine = getline(1)
    if stridx(firstLine, '// gcc') == 0
      let remainingChars = strpart(firstLine, strlen('// gcc'))
      exec '!gcc % -o %< -g3 -O0 -Wall -std=c17 ' remainingChars '&& ./%<'
    else
      exec '!gcc % -o %< -g3 -O0 -Wall -std=c17 && ./%<'
    endif
  elseif &filetype == 'cpp'
    if filereadable('Makefile')
      exec '!make -j4 && ./a.out'
    elseif filereadable('CMakeLists.txt')
      exec '!cmake . && make -j4 && ./a.out'
    else
      let firstLine = getline(1)
      if stridx(firstLine, '// g++') == 0
        let remainingChars = strpart(firstLine, strlen('// g++'))
        exec '!g++ % -o %< -g -Wall -std=c++14 ' remainingChars '&& ./%<'
      else
        exec '!g++ % -o %< -g -Wall -std=c++14 && ./%<'
      endif
    endif
  elseif &filetype == 'python'
    let firstLine = getline(1)
    if stridx(firstLine, '#manim') == 0
      let remainingChars = strpart(firstLine, strlen('#manim'))
      exec '!manim ' remainingChars ' % Demo'
    else
      exec '!python3 %'
    endif
  elseif &filetype == 'sh'
    :! bash %
  elseif &filetype == 'tex'
    normal \ll
  elseif &filetype == 'markdown'
    :MarkdownPreview
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
    call setline(1, "#!/usr/local/bin/python3")
  endif
  call setline(2,"")
  normal G
endfunc
" }

