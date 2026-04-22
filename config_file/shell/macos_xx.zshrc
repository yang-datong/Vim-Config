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
alias ls='ls -GF'

[[ -r "$SH_FOOT/config_file/shell/xx.zsh_theme_shared.zsh" ]] && source "$SH_FOOT/config_file/shell/xx.zsh_theme_shared.zsh"
[[ -r "$SH_FOOT/config_file/shell/xx.nvim_cursor_reset.zsh" ]] && source "$SH_FOOT/config_file/shell/xx.nvim_cursor_reset.zsh"
