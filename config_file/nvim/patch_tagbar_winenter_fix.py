#!/usr/bin/env python3

from __future__ import annotations

from pathlib import Path
import subprocess
import sys
import time


OLD_VAR = "let s:vim_quitting = 0\n"
NEW_VAR = "let s:vim_quitting = 0\nlet s:handleonlywindow_pending = 0\n"

OLD_FUNC = '''" s:HandleOnlyWindow() {{{2
function! s:HandleOnlyWindow() abort
    let tagbarwinnr = bufwinnr(s:TagbarBufName())
    if tagbarwinnr == -1
        return
    endif

    let vim_quitting = s:vim_quitting
    let s:vim_quitting = 0

    let file_open = s:HasOpenFileWindows()

    if vim_quitting && file_open == 2 && !g:tagbar_autoclose_netrw
        call tagbar#debug#log('Closing Tagbar due to QuitPre - netrw only remaining window')
        call s:CloseWindow()
        return
    endif

    if vim_quitting && file_open != 1
        call tagbar#debug#log('Closing Tagbar window due to QuitPre event')
        if winnr('$') >= 1
            call s:goto_win(tagbarwinnr, 1)
        endif

        " Before quitting Vim, delete the tagbar buffer so that the '0 mark is
        " correctly set to the previous buffer.
        if tabpagenr('$') == 1
            noautocmd keepalt bdelete
        endif

        try
            try
                quit
            catch /.*/ " This can be E173 and maybe others
                call s:OpenWindow('')
                echoerr v:exception
            endtry
        catch /.*/
            echohl ErrorMsg
            echo v:exception
            echohl None
        endtry
    endif
endfunction
'''

NEW_FUNC = '''" s:HandleOnlyWindowDeferred() {{{2
function! s:HandleOnlyWindowDeferred(tagbarwinnr, file_open) abort
    let s:handleonlywindow_pending = 0

    if a:file_open == 2 && !g:tagbar_autoclose_netrw
        call tagbar#debug#log('Closing Tagbar due to QuitPre - netrw only remaining window')
        call s:CloseWindow()
        return
    endif

    if a:file_open == 1
        return
    endif

    call tagbar#debug#log('Closing Tagbar window due to QuitPre event')
    if winnr('$') >= 1
        call s:goto_win(a:tagbarwinnr, 1)
    endif

    " Before quitting Vim, delete the tagbar buffer so that the '0 mark is
    " correctly set to the previous buffer.
    if tabpagenr('$') == 1
        noautocmd keepalt bdelete
    endif

    try
        try
            quit
        catch /.*/ " This can be E173 and maybe others
            call s:OpenWindow('')
            echoerr v:exception
        endtry
    catch /.*/
        echohl ErrorMsg
        echo v:exception
        echohl None
    endtry
endfunction

" s:HandleOnlyWindow() {{{2
function! s:HandleOnlyWindow() abort
    let tagbarwinnr = bufwinnr(s:TagbarBufName())
    if tagbarwinnr == -1
        return
    endif

    let vim_quitting = s:vim_quitting
    let s:vim_quitting = 0

    let file_open = s:HasOpenFileWindows()
    if !vim_quitting || file_open == 1 || s:handleonlywindow_pending
        return
    endif

    let s:handleonlywindow_pending = 1
    if exists('*timer_start')
        call timer_start(0, {-> s:HandleOnlyWindowDeferred(tagbarwinnr, file_open)})
    else
        call s:HandleOnlyWindowDeferred(tagbarwinnr, file_open)
    endif
endfunction
'''


def default_tagbar_path() -> Path:
    try:
        result = subprocess.run(
            ["nvim", "--headless", "+lua io.write(vim.fn.stdpath('data'))", "+qall"],
            check=True,
            capture_output=True,
            text=True,
        )
        data_dir = result.stdout.strip()
        if data_dir:
            return Path(data_dir) / "lazy/tagbar/autoload/tagbar.vim"
    except FileNotFoundError:
        print("nvim not found in PATH", file=sys.stderr)
        raise SystemExit(1)
    except subprocess.CalledProcessError as exc:
        print("failed to query nvim stdpath('data')", file=sys.stderr)
        if exc.stderr:
            print(exc.stderr.strip(), file=sys.stderr)
        raise SystemExit(1)

    print("nvim stdpath('data') returned an empty path", file=sys.stderr)
    raise SystemExit(1)


def patch_tagbar(path: Path) -> int:
    if not path.is_file():
        print(f"tagbar file not found: {path}", file=sys.stderr)
        return 1

    text = path.read_text(encoding="utf-8")

    if "HandleOnlyWindowDeferred(tagbarwinnr, file_open)" in text and "let s:handleonlywindow_pending = 0" in text:
        print(f"already patched: {path}")
        return 0

    if OLD_VAR not in text:
        print("failed to find s:vim_quitting definition", file=sys.stderr)
        return 1

    if OLD_FUNC not in text:
        print("failed to find original HandleOnlyWindow() block", file=sys.stderr)
        return 1

    updated = text.replace(OLD_VAR, NEW_VAR, 1).replace(OLD_FUNC, NEW_FUNC, 1)

    backup = path.with_name(f"{path.name}.bak.{time.strftime('%Y%m%d%H%M%S')}")
    backup.write_text(text, encoding="utf-8")
    path.write_text(updated, encoding="utf-8")

    print(f"patched: {path}")
    print(f"backup:  {backup}")
    return 0


def main() -> int:
    target = Path(sys.argv[1]).expanduser() if len(sys.argv) > 1 else default_tagbar_path()
    return patch_tagbar(target)


if __name__ == "__main__":
    raise SystemExit(main())
