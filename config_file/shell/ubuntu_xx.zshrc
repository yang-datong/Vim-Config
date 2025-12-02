export ZSH="$HOME/.oh-my-zsh"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000

setopt prompt_subst
autoload -Uz add-zsh-hook colors
colors


export PATH=$PATH:$HOME/.local/bin/
export PATH=$PATH:$HOME/MySoftWare/jadx/bin

export SH_FOOT=$HOME/sh_foot
export CLOUD=/run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
export ANDROID_NDK_HOME=$HOME/Android/Sdk/ndk/25.1.8937393
export TMPDIR=/tmp/

AI_KEY_FILE="$HOME/.AI-Key.txt"
if [[ -r "$AI_KEY_FILE" ]]; then
  export GEMINI_API_KEY="$(awk '/GEMINI_API_KEY/ {print $2}' "$AI_KEY_FILE")"
  export AVANTE_GEMINI_API_KEY="$GEMINI_API_KEY"
  export OPENAI_API_KEY="$(awk '/OPENAI_API_KEY/ {print $2}' "$AI_KEY_FILE")"
  export AVANTE_OPENAI_API_KEY="$OPENAI_API_KEY"
fi

# Aliases & helpers
source "$HOME/.common_aliases.sh"
alias cat='batcat -p'
alias apt='sudo apt'
alias ida='wine /home/hi/MySoftWare/IDA_Pro_7.7/ida64.exe'

set-proxy

[[ -f "$HOME/.autojump/share/autojump/autojump.zsh" ]] && source "$HOME/.autojump/share/autojump/autojump.zsh"

plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"
















# ----------------------- 颜色主题配置（模拟fish，一般不需要改动） -------------------------------
typeset -gA ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[parameter]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[default]='fg=#e5e9f0'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES[option]='fg=#8fbcbb'
ZSH_HIGHLIGHT_STYLES[path]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#b48ead,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#4c566a,italic'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#bf616a,bold'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[function]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#d08770'
ZSH_HIGHLIGHT_STYLES[history-substitution]='fg=#ebcb8b'
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4c566a'
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="rs=0:di=38;5;33:ln=38;5;38:mh=00:pi=40;38;5;226:so=38;5;13:do=38;5;5:bd=40;38;5;226:cd=40;38;5;226:or=40;38;5;221:mi=00:su=38;5;1:sg=38;5;16:ca=38;5;9:tw=40;38;5;222:ow=38;5;34:st=40;38;5;13:ex=38;5;121:"
zmodload zsh/complist
zstyle ':completion:*' list-colors \
  'default=0;97' \
  'di=0;97' \
  'fi=0;97' \
  'ln=0;97' \
  'pi=0;97' \
  'so=0;97' \
  'bd=0;97' \
  'cd=0;97' \
  'or=0;97' \
  'mi=0;97' \
  'ex=0;97'
zstyle ':completion:*' menu no-select

prompt_virtualenv_segment() {
  [[ -n "$VIRTUAL_ENV" ]] && printf "[%s] " "${VIRTUAL_ENV:t}"
}

prompt_git_segment() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return
  local branch
  branch="$(command git symbolic-ref --quiet --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)"
  printf "(%s) " "$branch"
}

prompt_compact_path() {
  local path="$PWD" prefix=""
  if [[ "$path" == "$HOME"* ]]; then
    path="~${path#$HOME}"
  elif [[ "$path" == /* ]]; then
    prefix="/"
    path="${path#/}"
  fi

  local -a segments
  IFS='/' segments=(${=path})
  local result="" seg_count=${#segments} idx seg truncated
    for (( idx=1; idx<=seg_count; idx++ )); do
      seg="${segments[idx]}"
      [[ -z "$seg" ]] && continue
      if [[ "$seg" == "~" ]]; then
        truncated="$seg"
      elif (( idx < seg_count )); then
        truncated="${seg[1,1]}"
      else
        truncated="$seg"
      fi
      result+="$truncated"
      (( idx < seg_count )) && result+="/"
    done

    [[ -z "$result" ]] && result="$prefix" || result="$prefix$result"
    print -r -- "$result"
  }

prompt_path_segment() {
  local pretty_path
  pretty_path="$(prompt_compact_path)"
  printf "%s" "%F{blue}[%f%F{yellow}${pretty_path}%f%F{blue}]%f"
}

prompt_refresh_segments() {
  PROMPT_VENV_SEGMENT="$(prompt_virtualenv_segment)"
  PROMPT_GIT_SEGMENT="$(prompt_git_segment)"
  PROMPT_PATH_SEGMENT="$(prompt_path_segment)"
}

add-zsh-hook precmd prompt_refresh_segments

PROMPT='%(?.%F{white}$ %f.%F{red}$ %f)'
RPROMPT='%F{244}${PROMPT_VENV_SEGMENT}${PROMPT_GIT_SEGMENT}%f${PROMPT_PATH_SEGMENT}'
