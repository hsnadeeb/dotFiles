# ~/.zshrc
# Structured, performance-minded Zsh config for interactive development shells.

# -----------------------------------------------------------------------------
# 01) Environment and PATH
# -----------------------------------------------------------------------------

# Keep PATH unique while preserving insertion order.
typeset -gU path PATH

# Environment variables used by tools.
export HISTFILE="$HOME/.zsh_history"

# PATH helpers.
_zshrc_path_prepend_if_dir() {
  [[ -d "$1" ]] && path=("$1" $path)
}

_zshrc_path_prepend_if_set_dir() {
  local dir="$1"
  [[ -n "$dir" && -d "$dir" ]] && path=("$dir" $path)
}

# Tool paths (most important first).
_zshrc_path_prepend_if_dir "/Applications/IntelliJ IDEA.app/Contents/MacOS"
_zshrc_path_prepend_if_dir "/opt/homebrew/bin"
_zshrc_path_prepend_if_dir "/usr/local/bin"
_zshrc_path_prepend_if_set_dir "${JAVA_HOME:+$JAVA_HOME/bin}"
_zshrc_path_prepend_if_dir "$HOME/go/bin"
_zshrc_path_prepend_if_dir "$HOME/.local/bin"
_zshrc_path_prepend_if_dir "$HOME/.jenv/bin"
_zshrc_path_prepend_if_dir "$HOME/.codeium/windsurf/bin"
_zshrc_path_prepend_if_set_dir "${ANDROID_HOME:+$ANDROID_HOME/platform-tools}"
_zshrc_path_prepend_if_set_dir "${ANDROID_HOME:+$ANDROID_HOME/emulator}"
_zshrc_path_prepend_if_set_dir "${ANDROID_HOME:+$ANDROID_HOME/tools/bin}"
_zshrc_path_prepend_if_set_dir "${ANDROID_HOME:+$ANDROID_HOME/tools}"

# Skip interactive-only setup for non-interactive shells.
[[ $- != *i* ]] && return

# -----------------------------------------------------------------------------
# 02) History
# -----------------------------------------------------------------------------

HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY
setopt HIST_FIND_NO_DUPS

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# -----------------------------------------------------------------------------
# 03) Shell behavior
# -----------------------------------------------------------------------------

setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt EXTENDED_GLOB
setopt NO_CASE_GLOB
setopt GLOB_DOTS
setopt NO_BEEP
setopt INTERACTIVE_COMMENTS

# Disable flow control to keep Ctrl-S/Ctrl-Q usable in terminal apps.
unsetopt FLOW_CONTROL

# -----------------------------------------------------------------------------
# 04) Completion
# -----------------------------------------------------------------------------

[[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"
autoload -Uz add-zsh-hook

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh_completion_cache"
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*' \
  'l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' rehash true
zstyle ':completion:*' accept-exact '*(N)'

autoload -Uz compinit
typeset -gi __ZSHRC_COMPINIT_LOADED=0

_zshrc_load_compinit_once() {
  (( __ZSHRC_COMPINIT_LOADED )) && return
  __ZSHRC_COMPINIT_LOADED=1

  compinit -C -d "$HOME/.cache/zcompdump"
  bindkey '^I' expand-or-complete
  bindkey '^[[Z' reverse-menu-complete
}

_zshrc_lazy_tab_complete() {
  _zshrc_load_compinit_once
  zle expand-or-complete
}

zle -N _zshrc_lazy_tab_complete
bindkey '^I' _zshrc_lazy_tab_complete

# Auto-initialize completion on first executed command in a new shell,
# while keeping lazy Tab as a fallback path.
_zshrc_compinit_on_first_command() {
  add-zsh-hook -d preexec _zshrc_compinit_on_first_command
  _zshrc_load_compinit_once
}
add-zsh-hook preexec _zshrc_compinit_on_first_command

# -----------------------------------------------------------------------------
# 05) Prompt (fast git branch + dirty marker + exit code)
# -----------------------------------------------------------------------------

typeset -g __ZSHRC_GIT_PROMPT_CACHE=""
typeset -g __ZSHRC_EXIT_CODE_CACHE=""

_zshrc_update_git_prompt() {
  command -v git >/dev/null 2>&1 || {
    __ZSHRC_GIT_PROMPT_CACHE=""
    return
  }

  git rev-parse --is-inside-work-tree >/dev/null 2>&1 || {
    __ZSHRC_GIT_PROMPT_CACHE=""
    return
  }

  local branch marks=""
  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)" || \
    branch="$(git rev-parse --short HEAD 2>/dev/null)"

  [[ -z "$branch" ]] && {
    __ZSHRC_GIT_PROMPT_CACHE=""
    return
  }

  # Lightweight dirty check excluding untracked files.
  if git status --porcelain -uno 2>/dev/null | read -r; then
    marks="✚"
  fi

  __ZSHRC_GIT_PROMPT_CACHE=" %F{240}on%f %F{142}${branch}%f${marks:+ %F{208}${marks}%f}"
}

_zshrc_update_exit_code() {
  local code=$?
  if (( code == 0 )); then
    __ZSHRC_EXIT_CODE_CACHE=""
  else
    __ZSHRC_EXIT_CODE_CACHE=" %F{red}✘ ${code}%f"
  fi
}

add-zsh-hook chpwd _zshrc_update_git_prompt
add-zsh-hook precmd _zshrc_update_exit_code
add-zsh-hook precmd _zshrc_update_git_prompt

setopt PROMPT_SUBST
PROMPT='%(?.%F{142}.%F{167})%n%f %F{240}in%f %F{108}%~%f${__ZSHRC_GIT_PROMPT_CACHE}${__ZSHRC_EXIT_CODE_CACHE}
%F{red}❯%f '

# -----------------------------------------------------------------------------
# 06) Mise lazy init
# -----------------------------------------------------------------------------

typeset -gi __ZSHRC_MISE_LOADED=0

_zshrc_load_mise_once() {
  (( __ZSHRC_MISE_LOADED )) && return
  command -v mise >/dev/null 2>&1 || return

  __ZSHRC_MISE_LOADED=1
  eval "$(mise activate zsh)"
}

add-zsh-hook chpwd _zshrc_load_mise_once

mise() {
  _zshrc_load_mise_once
  command mise "$@"
}

# -----------------------------------------------------------------------------
# 07) Aliases (general)
# -----------------------------------------------------------------------------

alias zshrc='nvim ~/.zshrc'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'

# ls family
alias l='ls -lFh'
alias la='ls -lAFh'
alias ll='ls -l'

# Safer coreutils
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rm='rm -i'
alias rmd='rm -rf'

# Permissions and utilities
alias ax='chmod a+x'
alias make-exe='chmod 700'
alias symlink='ln -s'
alias path='echo -e ${PATH//:/\\n}'
alias please='sudo !!'

# Development helpers
alias shfmt='shfmt -ci -bn -i 2'
alias sc='shellcheck --exclude=2001,2148'
alias grep='grep --color=always'

# List helpers
alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/{$//'"

# Network
alias ip='curl ifconfig.me'
alias ip-wifi='ipconfig getifaddr en0'
alias ip-wired='ipconfig getifaddr en1'

# Git
alias gs='git status'
alias gst='git stash'
alias gsp='git stash pop'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gf='git fetch'
alias gp='git push'
alias gl='git pull --rebase'
alias gd='git diff'
alias lg='lazygit'

# Project shortcuts
alias projects='cd ~/Projects && la'
alias nvconf='cd ~/.config/nvim'
alias wello='cd ~/Projects/Wello && la'
alias shaz='cd ~/Projects/Shaz && la'
alias notes='cd ~/Projects/Learning/VSCodeNotes && nvim .'
alias be='cd ~/Projects/Wello/vital-ecare-backend && npm run dev'
alias fe='cd ~/Projects/Wello/vital-ecare-frontend && npm start'
alias x3rph='cd ~/oracle/X3rph && ssh -i x3rph.key ubuntu@161.118.167.226'
alias doom='cd ~/Projects/Games/terminal-doom && ./zig-out/bin/terminal-doom'

# -----------------------------------------------------------------------------
# 08) Docker and infra aliases
# -----------------------------------------------------------------------------

alias dk='docker compose'

alias kafka-up='cd ~/docker/kafka && dk up -d'
alias kafka-down='cd ~/docker/kafka && dk down'
alias redis-up='cd ~/docker/redis && dk up -d'
alias redis-down='cd ~/docker/redis && dk down'
alias pg-up='cd ~/docker/postgres && dk up -d'
alias pg-down='cd ~/docker/postgres && dk down'
alias mysql-up='cd ~/docker/mysql && dk up -d'
alias mysql-down='cd ~/docker/mysql && dk down'

alias infra-up='kafka-up && redis-up && pg-up && mysql-up'
alias infra-down='kafka-down && redis-down && pg-down && mysql-down'

alias kafka-logs='docker logs -f kafka'
alias kafka-ui-logs='docker logs -f kafka-ui'

# -----------------------------------------------------------------------------
# 09) System monitoring
# -----------------------------------------------------------------------------

alias memHogs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

mine() {
  ps "$@" -u "${USER}" -o pid,%cpu,%mem,start,time,bsdtime,command
}

# -----------------------------------------------------------------------------
# 10) Lazy loading for nvm / node tools
# -----------------------------------------------------------------------------

typeset -gi __ZSHRC_NVM_LOADED=0

_zshrc_load_nvm_once() {
  (( __ZSHRC_NVM_LOADED )) && return
  __ZSHRC_NVM_LOADED=1

  unfunction nvm node npm npx yarn pnpm 2>/dev/null

  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

  [[ -f .nvmrc ]] && nvm use --silent >/dev/null 2>&1
}

_zshrc_lazy_nvm_exec() {
  local cmd="$1"
  shift
  _zshrc_load_nvm_once
  command "$cmd" "$@"
}

nvm() { _zshrc_lazy_nvm_exec nvm "$@"; }
node() { _zshrc_lazy_nvm_exec node "$@"; }
npm() { _zshrc_lazy_nvm_exec npm "$@"; }
npx() { _zshrc_lazy_nvm_exec npx "$@"; }
yarn() { _zshrc_lazy_nvm_exec yarn "$@"; }
pnpm() { _zshrc_lazy_nvm_exec pnpm "$@"; }

# -----------------------------------------------------------------------------
# 11) FZF history widget
# -----------------------------------------------------------------------------

__fzf_history_widget() {
  local selected
  selected="$(builtin fc -rl 1 | fzf --tac --no-sort --exact --height=40% --reverse --border --inline-info)"
  [[ -n "$selected" ]] || {
    zle reset-prompt
    return
  }

  BUFFER="${${selected##[[:space:]]#<->[[:space:]]#}:-$selected}"
  CURSOR=${#BUFFER}
  zle reset-prompt
}

zle -N __fzf_history_widget
bindkey '^R' __fzf_history_widget

# -----------------------------------------------------------------------------
# 12) Deferred plugin loading (after first prompt)
# -----------------------------------------------------------------------------

_zshrc_load_enhancements() {
  add-zsh-hook -d precmd _zshrc_load_enhancements

  local brew='/opt/homebrew'

  # zsh-autosuggestions
  local autosuggest="$brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  if [[ -f "$autosuggest" ]]; then
    source "$autosuggest"
    ZSH_AUTOSUGGEST_STRATEGY=(history)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=15
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999999,bg=default,underline'
  fi

  # fast-syntax-highlighting
  local highlighting="$brew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  if [[ -f "$highlighting" ]]; then
    source "$highlighting"
    typeset -gA FAST_HIGHLIGHT
    FAST_HIGHLIGHT[use_async]=1
    unset 'FAST_HIGHLIGHT_STYLES[path]' 'FAST_HIGHLIGHT_STYLES[path_prefix]' \
      'FAST_HIGHLIGHT_STYLES[globbing]' 2>/dev/null
  fi
}

add-zsh-hook precmd _zshrc_load_enhancements

# -----------------------------------------------------------------------------
# 13) Utility functions
# -----------------------------------------------------------------------------

mkcd() {
  [[ -n "$1" ]] && mkdir -p "$1" && cd "$1"
}

killproc() {
  [[ -z "$1" ]] && {
    echo 'Usage: killproc <pattern>'
    return 1
  }

  echo "Processes matching '$1':"
  pgrep -af -- "$1" 2>/dev/null || {
    echo '  (none found)'
    return 1
  }

  printf 'Kill all? [y/N] '
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]] && pkill -f -- "$1" && echo 'Killed.'
}

extract() {
  local f="$1"
  [[ -f "$f" ]] || {
    echo "File not found: $f"
    return 1
  }

  case "$f" in
    *.tar.bz2) tar xjf "$f" ;;
    *.tar.gz) tar xzf "$f" ;;
    *.bz2) bunzip2 "$f" ;;
    *.gz) gunzip "$f" ;;
    *.tar) tar xf "$f" ;;
    *.tbz2) tar xjf "$f" ;;
    *.tgz) tar xzf "$f" ;;
    *.zip) unzip "$f" ;;
    *.Z) uncompress "$f" ;;
    *.7z) 7z x "$f" ;;
    *)
      echo "Cannot extract '$f'"
      return 1
      ;;
  esac
}

dirinfo() {
  local d="${1:-.}"
  [[ -d "$d" ]] || {
    echo "Not a directory: $d"
    return 1
  }

  echo "Directory: $d"
  echo "Size:       $(du -sh "$d" | cut -f1)"
  echo "Files:      $(find "$d" -type f | wc -l | tr -d ' ')"
  echo "Dirs:       $(find "$d" -type d | wc -l | tr -d ' ')"
}

colors() {
  local i
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f "
    [[ $(( i % 6 )) -eq 3 ]] && print
  done
}

# -----------------------------------------------------------------------------
# 14) macOS-specific helpers
# -----------------------------------------------------------------------------

if [[ "$OSTYPE" == darwin* ]]; then
  # Clipboard and screenshots
  alias cpwd='pwd | tr -d "\n" | pbcopy'
  alias cl='fc -e - | pbcopy'
  alias caff='caffeinate -ism'
  alias capc='screencapture -c'
  alias capic='screencapture -i -c'
  alias capiwc='screencapture -i -w -c'

  CAPTURE_FOLDER="$HOME/Desktop"

  cap() { screencapture "$CAPTURE_FOLDER/capture-$(date +%Y%m%d_%H%M%S).png"; }
  capi() { screencapture -i "$CAPTURE_FOLDER/capture-$(date +%Y%m%d_%H%M%S).png"; }
  capiw() { screencapture -i -w "$CAPTURE_FOLDER/capture-$(date +%Y%m%d_%H%M%S).png"; }

  # Finder and Quick Look
  alias cleanDS="find . -type f -name '*.DS_Store' -ls -delete"
  alias showHidden='defaults write com.apple.finder AppleShowAllFiles TRUE'
  alias hideHidden='defaults write com.apple.finder AppleShowAllFiles FALSE'
  alias cleanupLS='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder'

  f() { open -a 'Finder' "${1:-.}"; }
  ql() { qlmanage -p "$@" >/dev/null 2>&1; }

  unquarantine() {
    local attr
    for attr in \
      com.apple.metadata:kMDItemDownloadedDate \
      com.apple.metadata:kMDItemWhereFroms \
      com.apple.quarantine; do
      xattr -r -d "$attr" "$@" 2>/dev/null
    done
  }

  # Spotlight
  alias spot-off='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
  alias spot-on='sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
  alias spot-file="lsof -c '/mds$/'"

  spotlight() {
    [[ -z "$1" ]] && {
      echo 'Usage: spotlight <name>'
      return 1
    }
    mdfind "kMDItemDisplayName == '$1'wc"
  }
fi
