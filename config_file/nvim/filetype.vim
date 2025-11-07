
augroup filetypedetect
    au! BufRead,BufNewFile *.math setfiletype math
    au! BufRead,BufNewFile *.manim setfiletype manim
    ".asm文件都是nasm(x86)语法
    au! BufRead,BufNewFile *.asm setfiletype nasm
    ".s/S文件都是gas(arm)语法
    "au! BufRead,BufNewFile *.s setfiletype asm
    "au! BufRead,BufNewFile *.S setfiletype asm
augroup END

