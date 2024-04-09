"README: 这个文件全都是从主要是用于unite 的配置

"- `autocmd FileType unite call s:unite_my_settings()`：这行代码的意思是，当你打开的文件类型（FileType）是 unite 时，会自动调用 `s:unite_my_settings()` 这个函数。
"- `function! s:unite_my_settings()`：这是一个函数的定义，函数名为 `s:unite_my_settings`。这个函数中的代码主要是对 unite 插件的一些设置进行了自定义。
"- `imap <buffer> jj <Plug>(unite_insert_leave)`：这行代码的意思是，在插入模式（insert mode）下，当你在当前缓冲区（buffer）输入 `jj` 时，会触发 unite 插件的 `unite_insert_leave` 动作。
"- `imap <buffer><expr> j unite#smart_map('j', '')`：这行代码的意思是，在插入模式下，当你在当前缓冲区输入 `j` 时，会触发 unite 插件的 `smart_map` 动作。
"- `let g:deoplete#enable_at_startup = 1`：这行代码的意思是，当你启动 Vim 时，会自动启用 deoplete 插件。
"- `inoremap <expr><tab> pumvisible() ? "\<c-n>" :"\<tab>"`：这行代码的意思是，在插入模式下，当你输入 Tab 键时，如果弹出菜单（popup menu）是可见的，那么就会触发 `<C-n>` 动作，否则就会触发 `<Tab>` 动作。

"autocmd FileType unite call s:unite_my_settings()
"function! s:unite_my_settings()"{{{
"  " Overwrite settings.
"  imap <buffer> jj      <Plug>(unite_insert_leave)
"  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
"
"  imap <buffer><expr> j unite#smart_map('j', '')
"  imap <buffer> <TAB>   <Plug>(unite_select_next_line)
"  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
"  imap <buffer> '     <Plug>(unite_quick_match_default_action)
"  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
"  imap <buffer><expr> x
"        \ unite#smart_map('x', "\<Plug>(unite_quick_match_jump)")
"  nmap <buffer> x     <Plug>(unite_quick_match_jump)
"  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
"  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
"  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
"  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
"  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
"  nnoremap <silent><buffer><expr> l
"        \ unite#smart_map('l', unite#do_action('default'))
"
"  let unite = unite#get_current_unite()
"  if unite.profile_name ==# 'search'
"    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
"  else
"    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
"  endif
"
"  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
"  nnoremap <buffer><expr> S      unite#mappings#set_current_sorters(
"        \ empty(unite#mappings#get_current_sorters()) ?
"
"  " Runs "split" action by <C-s>.
"  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
"endfunction"}}}
"" }
"
"" deoplete {
"  let g:deoplete#enable_at_startup = 1
"  "let g:deoplete#enable_smart_case = 1
"
"  "deoplete tab-complete
"  inoremap <expr><tab> pumvisible() ? "\<c-n>" :"\<tab>"
"  " }
"  "" }
