
augroup filetypedetect
    autocmd BufRead,BufNewFile *.math setfiletype math
    autocmd BufRead,BufNewFile *.manim setfiletype manim
    ".asm文件都是nasm(x86)语法
    autocmd BufRead,BufNewFile *.asm setfiletype nasm
    ".s/S文件都是gas(arm)语法
    autocmd BufRead,BufNewFile *.s setfiletype asm
    autocmd BufRead,BufNewFile *.S setfiletype asm
    autocmd BufRead,BufNewFile *.perf setfiletype asm
augroup END
