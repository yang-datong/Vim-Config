export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled
export DISABLE_AUTO_UPDATE="true"
export DISABLE_UPDATE_PROMPT="true"
# 提速：关闭 OMZ 终端标题钩子与 async git prompt 钩子
export DISABLE_AUTO_TITLE="true"
zstyle ':omz:alpha:lib:git' async-prompt no

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000

setopt prompt_subst
autoload -Uz add-zsh-hook colors
colors

# MacOS 环境
export PATH=/Applications/Inkscape.app/Contents/MacOS:$PATH
export PATH=$HOME/Library/Python/3.10/bin:$PATH
export PATH=$HOME/.local/bin:$PATH

export SH_FOOT=$HOME/sh_foot
export CLOUD=$HOME/Library/Mobile\ Documents/com~apple~CloudDocs
if [[ "$(uname -m)" == "arm64" ]]; then
  export ANDROID_NDK_HOME="/opt/homebrew/share/android-ndk"
  [[ ":$PATH:" != *":/opt/homebrew/bin:"* ]] && export PATH="/opt/homebrew/bin:$PATH"
else
  export ANDROID_NDK_HOME="$HOME/Library/Android/Sdk/ndk"
fi
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

AI_KEY_FILE="$HOME/.AI-Key.txt"
if [[ -r "$AI_KEY_FILE" ]]; then
  export GEMINI_API_KEY="$(awk '/GEMINI_API_KEY/ {print $2}' "$AI_KEY_FILE")"
  export AVANTE_GEMINI_API_KEY="$GEMINI_API_KEY"
  export OPENAI_API_KEY="$(awk '/OPENAI_API_KEY/ {print $2}' "$AI_KEY_FILE")"
  export AVANTE_OPENAI_API_KEY="$OPENAI_API_KEY"
fi

# Aliases & helpers
source "$HOME/.common_aliases.sh"
alias cat='bat -p'
alias gdb='lldb'
alias ldd='otool -L'
alias ida='/Applications/IDA\ Professional\ 9.0.app/Contents/MacOS/ida'

set-proxy

[[ -f "$HOME/.autojump/share/autojump/autojump.zsh" ]] && source "$HOME/.autojump/share/autojump/autojump.zsh"

# 提速：autosuggestions 不在每次 precmd 重绑 widgets
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"

# 进一步减少每次回车的无用钩子开销
add-zsh-hook -d precmd _omz_async_request 2>/dev/null
add-zsh-hook -d precmd omz_termsupport_precmd 2>/dev/null
add-zsh-hook -d precmd omz_termsupport_cwd 2>/dev/null
add-zsh-hook -d preexec omz_termsupport_preexec 2>/dev/null

# fish 风格 ls：保留颜色并显示类型后缀（软链接为 @）
alias ls='ls --color=auto -F'
















# ----------------------- fish 主题配置同步到 zsh -------------------------------
typeset -gA ZSH_HIGHLIGHT_STYLES
# fish 的普通参数颜色更接近 #d8dee9，而不是纯白
ZSH_HIGHLIGHT_STYLES[default]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=#bf616a,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[alias]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[command]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[function]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=#88c0d0'
ZSH_HIGHLIGHT_STYLES[parameter]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[assign]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[path]='fg=#d8dee9,underline'
ZSH_HIGHLIGHT_STYLES[path_prefix]='fg=#d8dee9'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#a3be8c'
ZSH_HIGHLIGHT_STYLES[option]='fg=#8fbcbb'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=#b48ead,bold'
ZSH_HIGHLIGHT_STYLES[named-fd]='fg=#b48ead,bold'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='fg=#b48ead,bold'
ZSH_HIGHLIGHT_STYLES[comment]='fg=#4c566a,italic'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[globbing]='fg=#81a1c1'
ZSH_HIGHLIGHT_STYLES[history-substitution]='fg=#e5e9f0,bold'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=#ebcb8b'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-unquoted]='fg=#ebcb8b'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter-quoted]='fg=#ebcb8b'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=#ebcb8b'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=#ebcb8b'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=#ebcb8b'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#4c566a'

# 保留 ls 文件类型颜色，补全菜单颜色走下方 fish pager 配置
export LSCOLORS="exfxcxdxbxegedabagacad"
export LS_COLORS="rs=0:di=38;5;33:ln=38;5;38:mh=00:pi=40;38;5;226:so=38;5;13:do=38;5;5:bd=40;38;5;226:cd=40;38;5;226:or=40;38;5;221:mi=00:su=38;5;1:sg=38;5;16:ca=38;5;9:tw=40;38;5;222:ow=38;5;34:st=40;38;5;13:ex=38;5;121:"

zmodload zsh/complist

# fish 风格 Tab 补全行为：大小写不敏感、首 Tab 列表、后续进入菜单选择、无蜂鸣
setopt AUTO_LIST
setopt AUTO_MENU
setopt COMPLETE_IN_WORD
setopt ALWAYS_TO_END
setopt LIST_TYPES
unsetopt LIST_BEEP
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu no-select select=2
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-dirs-first true

# fish_pager 颜色映射
zstyle ':completion:*' list-colors \
  'no=0;38;2;229;233;240' \
  'fi=0;38;2;229;233;240' \
  'di=0;38;2;229;233;240' \
  'ln=0;38;2;229;233;240' \
  'pi=0;38;2;229;233;240' \
  'so=0;38;2;229;233;240' \
  'bd=0;38;2;229;233;240' \
  'cd=0;38;2;229;233;240' \
  'or=0;38;2;229;233;240' \
  'mi=0;38;2;229;233;240' \
  'ex=0;38;2;229;233;240' \
  'ma=1;4;38;2;229;233;240;48;2;67;76;94' \
  'hi=0;38;2;229;233;240;48;2;67;76;94' \
  'du=0;38;2;229;233;240;48;2;67;76;94'
FISH_ITALIC_ON=$'%{\e[3m%}'
FISH_ITALIC_OFF=$'%{\e[23m%}'
zstyle ':completion:*:descriptions' format "%F{#ebcb8b}${FISH_ITALIC_ON}%d${FISH_ITALIC_OFF}%f"
zstyle ':completion:*:messages' format '%F{#3b4252}%K{#d08770} %d %k%f'
zstyle ':completion:*:warnings' format '%F{#bf616a}%d%f'
zstyle ':completion:*' list-prompt '%F{#3b4252}%K{#d08770} %p | %m/%M | %l/%L %k%f'
zstyle ':completion:*' select-prompt '%F{#3b4252}%K{#d08770} %p | %m/%M %k%f'

# fish 风格右提示符对齐：贴右显示且不做 transient 清除
ZLE_RPROMPT_INDENT=0
unsetopt TRANSIENT_RPROMPT

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

typeset -g PROMPT_SEGMENTS_DIRTY=1
typeset -g PROMPT_LAST_PWD=""
typeset -g PROMPT_LAST_VENV=""

prompt_mark_segments_dirty() {
  PROMPT_SEGMENTS_DIRTY=1
}

prompt_refresh_segments() {
  local current_pwd="$PWD"
  local current_venv="${VIRTUAL_ENV-}"
  if (( ! PROMPT_SEGMENTS_DIRTY )) \
    && [[ "$current_pwd" == "$PROMPT_LAST_PWD" ]] \
    && [[ "$current_venv" == "$PROMPT_LAST_VENV" ]]; then
    return
  fi

  PROMPT_VENV_SEGMENT="$(prompt_virtualenv_segment)"
  PROMPT_GIT_SEGMENT="$(prompt_git_segment)"
  PROMPT_PATH_SEGMENT="$(prompt_path_segment)"
  PROMPT_LAST_PWD="$current_pwd"
  PROMPT_LAST_VENV="$current_venv"
  PROMPT_SEGMENTS_DIRTY=0
}

add-zsh-hook precmd prompt_refresh_segments
add-zsh-hook preexec prompt_mark_segments_dirty

PROMPT='%(?.%F{#ffffff}$ %f.%F{red}$ %f)'
RPROMPT='%F{#555555}${PROMPT_VENV_SEGMENT}${PROMPT_GIT_SEGMENT}%f${PROMPT_PATH_SEGMENT}'
