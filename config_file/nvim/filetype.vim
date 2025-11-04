
augroup filetypedetect
    au! BufRead,BufNewFile *.math setfiletype math
    au! BufRead,BufNewFile *.manim setfiletype manim
    au! BufRead,BufNewFile *.s setfiletype arm
    au! BufRead,BufNewFile *.S setfiletype arm
augroup END

