export ZSH="$HOME/.oh-my-zsh"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=500000
export SAVEHIST=500000


# 提速：关闭 OMZ 终端标题钩子与 async git prompt 钩子
export DISABLE_AUTO_UPDATE="true"
export DISABLE_AUTO_TITLE="true"
export DISABLE_UPDATE_PROMPT="true"

zstyle ':omz:alpha:lib:git' async-prompt no
zstyle ':omz:update' mode disabled

setopt prompt_subst
autoload -Uz add-zsh-hook colors
colors

# Ubuntu 环境
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/MySoftWare/jadx/bin:$PATH

export SH_FOOT=$HOME/sh_foot
export CLOUD=/run/user/1000/gvfs/google-drive:host=gmail.com,user=gg546229768/0AG-EMH1t7aE4Uk9PVA/
export ANDROID_NDK_HOME=/usr/lib/android-ndk
export TMPDIR=/tmp

AI_KEY_FILE="$HOME/.AI-Key.txt"
if [[ -r "$AI_KEY_FILE" ]]; then
  export GEMINI_API_KEY="$(awk '/GEMINI_API_KEY/ {print $2}' "$AI_KEY_FILE")"
  export OPENAI_API_KEY="$(awk '/OPENAI_API_KEY/ {print $2}' "$AI_KEY_FILE")"
  export DEEPSEEK_API_KEY="$(awk '/DEEPSEEK_API_KEY/ {print $2}' "$AI_KEY_FILE")"
fi

[[ -f "$HOME/.autojump/share/autojump/autojump.zsh" ]] && source "$HOME/.autojump/share/autojump/autojump.zsh"

# 提速：autosuggestions 不在每次 precmd 重绑 widgets
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1
plugins=(git zsh-autosuggestions autojump zsh-syntax-highlighting)


# fish 风格历史：每个终端独立上下文，退出后合并到全局文件
unsetopt sharehistory
setopt incappendhistory
setopt appendhistory

# 进一步减少每次回车的无用钩子开销
add-zsh-hook -d precmd _omz_async_request 2>/dev/null
add-zsh-hook -d precmd omz_termsupport_precmd 2>/dev/null
add-zsh-hook -d precmd omz_termsupport_cwd 2>/dev/null
add-zsh-hook -d preexec omz_termsupport_preexec 2>/dev/null

source "$ZSH/oh-my-zsh.sh"

[[ -r "$SH_FOOT/config_file/shell/xx.zsh_theme_shared.zsh" ]] && source "$SH_FOOT/config_file/shell/xx.zsh_theme_shared.zsh"
[[ -r "$SH_FOOT/config_file/shell/xx.nvim_cursor_reset.zsh" ]] && source "$SH_FOOT/config_file/shell/xx.nvim_cursor_reset.zsh"
export LS_COLORS="rs=0:di=38;5;33:ln=38;5;205:mh=00:pi=40;38;5;226:so=38;5;13:do=38;5;5:bd=40;38;5;226:cd=40;38;5;226:or=40;38;5;221:mi=00:su=38;5;1:sg=38;5;16:ca=38;5;9:tw=40;38;5;222:ow=38;5;34:st=40;38;5;13:ex=38;5;196:"

# Aliases & helpers
source "$HOME/.common_aliases.sh"
alias ls='ls --color=auto -F'
alias apt='sudo apt'
alias cat='batcat -p'
alias ida='wine $HOME/MySoftWare/IDA_Pro_7.7/ida64.exe'

set-proxy

