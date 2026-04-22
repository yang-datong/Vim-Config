[[ -n "${XX_NVIM_CURSOR_RESET_LOADED-}" ]] && return
typeset -g XX_NVIM_CURSOR_RESET_LOADED=1

typeset -gi NVIM_CURSOR_NEEDS_RESET=0

# Reset terminal cursor to bar only after editor commands exit.
mark_nvim_cursor_reset_preexec() {
  [[ "$1" =~ '(^|[[:space:];|&()])(v|vim|nvim|neovim|nvimdiff)([[:space:];|&()]|$)' ]] || return
  NVIM_CURSOR_NEEDS_RESET=1
}

reset_cursor_after_nvim_precmd() {
  (( NVIM_CURSOR_NEEDS_RESET )) || return
  NVIM_CURSOR_NEEDS_RESET=0
  [[ -t 1 ]] || return

  local seq=$'\e[6 q'
  if [[ -n "${TMUX-}" ]]; then
    seq=$'\ePtmux;\e\e[6 q\e\\'
  fi
  print -n -- "$seq"
}

add-zsh-hook preexec mark_nvim_cursor_reset_preexec
add-zsh-hook precmd reset_cursor_after_nvim_precmd
