# ~/.zshrc
# Structured, performance-minded Zsh config for interactive development shells.
#
# Section map:
#   01  Environment & PATH
#   02  History
#   03  Shell behaviour
#   04  Completion (lazy)
#   05  Prompt  (git branch + dirty + exit-code)
#   06  Mise    (lazy)
#   07  NVM / Node tools (lazy)
#   08  FZF widgets
#   09  Plugin loading (deferred — after first prompt)
#   10  Aliases — general
#   11  Aliases — Docker / infra
#   12  Aliases — macOS
#   13  Utility functions

# ==============================================================================
# 01) ENVIRONMENT & PATH
# ==============================================================================

# Deduplicate PATH entries while preserving insertion order.
typeset -gU path PATH

export HISTFILE="$HOME/.zsh_history"

# Add a directory to the front of $path only if it exists.
_zrc_path_prepend() { [[ -d "$1" ]] && path=("$1" $path); }

_zrc_path_prepend "/Applications/IntelliJ IDEA.app/Contents/MacOS"
_zrc_path_prepend "/opt/homebrew/bin"
_zrc_path_prepend "/usr/local/bin"
_zrc_path_prepend "$HOME/go/bin"
_zrc_path_prepend "$HOME/.local/bin"
_zrc_path_prepend "$HOME/.jenv/bin"
_zrc_path_prepend "$HOME/.codeium/windsurf/bin"

# JAVA_HOME / ANDROID_HOME are optional; expand only when set and valid.
[[ -n "$JAVA_HOME"    ]] && _zrc_path_prepend "$JAVA_HOME/bin"
[[ -n "$ANDROID_HOME" ]] && {
  _zrc_path_prepend "$ANDROID_HOME/platform-tools"
  _zrc_path_prepend "$ANDROID_HOME/emulator"
  _zrc_path_prepend "$ANDROID_HOME/tools/bin"
  _zrc_path_prepend "$ANDROID_HOME/tools"
}

# Everything below is interactive-only.
[[ $- != *i* ]] && return

# ==============================================================================
# 02) HISTORY
# ==============================================================================

HISTSIZE=50000
SAVEHIST=50000

setopt APPEND_HISTORY       # Append rather than overwrite on exit.
setopt SHARE_HISTORY        # Share history across concurrent sessions.
setopt HIST_IGNORE_ALL_DUPS # Drop older duplicate entry when a new one appears.
setopt HIST_REDUCE_BLANKS   # Strip superfluous whitespace before saving.
setopt HIST_VERIFY          # Show expanded history substitution before running.
setopt HIST_FIND_NO_DUPS    # Skip duplicates during history search.

bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward

# ==============================================================================
# 03) SHELL BEHAVIOUR
# ==============================================================================

setopt AUTO_CD              # Type a directory name to cd into it.
setopt AUTO_PUSHD           # cd pushes onto the directory stack.
setopt PUSHD_IGNORE_DUPS    # Don't push duplicate dirs.
setopt EXTENDED_GLOB        # Extended globbing patterns (#, ~, ^).
setopt NO_CASE_GLOB         # Case-insensitive globbing.
setopt GLOB_DOTS            # Include dotfiles in glob results.
setopt NO_BEEP              # Silence the terminal bell.
setopt INTERACTIVE_COMMENTS # Allow # comments at the prompt.

unsetopt FLOW_CONTROL       # Free up Ctrl-S / Ctrl-Q for other tools.

# Power-user rename: zmv '(*).txt' '$1.md'
autoload -Uz zmv

# ==============================================================================
# 04) COMPLETION  (lazy — deferred to first Tab or first executed command)
# ==============================================================================

[[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"
autoload -Uz add-zsh-hook

zstyle ':completion:*' use-cache       on
zstyle ':completion:*' cache-path      "$HOME/.cache/zsh_completion_cache"
zstyle ':completion:*' matcher-list    'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=*'
zstyle ':completion:*' menu            select
zstyle ':completion:*' rehash          true
zstyle ':completion:*' accept-exact    '*(N)'

autoload -Uz compinit
typeset -gi _ZRC_COMPINIT_DONE=0

_zrc_compinit_once() {
  (( _ZRC_COMPINIT_DONE )) && return
  _ZRC_COMPINIT_DONE=1

  compinit -C -d "$HOME/.cache/zcompdump"
  bindkey '^I'   expand-or-complete
  bindkey '^[[Z' reverse-menu-complete
}

# Lazy Tab: initialise on first press.
_zrc_lazy_tab() { _zrc_compinit_once; zle expand-or-complete; }
zle -N _zrc_lazy_tab
bindkey '^I' _zrc_lazy_tab

# Also initialise before the very first command so completions are ready.
_zrc_compinit_on_first_cmd() {
  add-zsh-hook -d preexec _zrc_compinit_on_first_cmd
  _zrc_compinit_once
}
add-zsh-hook preexec _zrc_compinit_on_first_cmd

# ==============================================================================
# 05) PROMPT  (git branch + dirty marker + exit-code indicator)
# ==============================================================================
# IMPORTANT: _zrc_capture_exit must be added to precmd FIRST so that it reads
# $? before any other hook (git or otherwise) resets it to 0.

typeset -g _ZRC_GIT_INFO=""
typeset -g _ZRC_EXIT_INDICATOR=""

_zrc_capture_exit() {
  # Called first in precmd; $? still reflects the user's last command.
  local code=$?
  _ZRC_EXIT_INDICATOR=$(( code == 0 )) && _ZRC_EXIT_INDICATOR="" \
    || _ZRC_EXIT_INDICATOR=" %F{red}✘ ${code}%f"
}

_zrc_update_git_info() {
  command -v git &>/dev/null || { _ZRC_GIT_INFO=""; return; }
  git rev-parse --is-inside-work-tree &>/dev/null || { _ZRC_GIT_INFO=""; return; }

  local branch
  branch="$(git symbolic-ref --quiet --short HEAD 2>/dev/null)" \
    || branch="$(git rev-parse --short HEAD 2>/dev/null)"
  [[ -z "$branch" ]] && { _ZRC_GIT_INFO=""; return; }

  # Lightweight dirty check (tracked files only — untracked skipped for speed).
  local dirty=""
  git status --porcelain -uno 2>/dev/null | IFS= read -r && dirty=" %F{208}✚%f"

  _ZRC_GIT_INFO=" %F{240}on%f %F{142}${branch}%f${dirty}"
}

# Hook order matters: exit capture must precede git update.
add-zsh-hook precmd _zrc_capture_exit
add-zsh-hook precmd _zrc_update_git_info
add-zsh-hook chpwd  _zrc_update_git_info

setopt PROMPT_SUBST
PROMPT='
 %(?.%F{142}.%F{167})%n%f %F{240}in%f %F{108}%~%f${_ZRC_GIT_INFO}${_ZRC_EXIT_INDICATOR}
 %F{red}❯%f '

# ==============================================================================
# 06) MISE  (lazy — activated on chpwd and preexec)
# ==============================================================================

typeset -gi _ZRC_MISE_DONE=0

_zrc_mise_once() {
  (( _ZRC_MISE_DONE )) && return
  command -v mise &>/dev/null || return
  _ZRC_MISE_DONE=1
  eval "$(mise activate zsh)"
}

# Activate when entering a directory (picks up .mise.toml) or on first command.
add-zsh-hook chpwd  _zrc_mise_once
add-zsh-hook preexec _zrc_mise_once

# Stub so `mise <args>` works before the first trigger fires.
mise() { _zrc_mise_once; command mise "$@"; }

# ==============================================================================
# 07) NVM / NODE TOOLS  (lazy — stub functions replaced on first use)
# ==============================================================================
# BUG FIX: the original used `command nvm` after sourcing nvm.sh, but nvm is a
# *shell function*, so `command` bypasses it. We use plain function lookup here.

typeset -gi _ZRC_NVM_DONE=0

_zrc_nvm_once() {
  (( _ZRC_NVM_DONE )) && return
  _ZRC_NVM_DONE=1

  # Remove stubs so real implementations take over after sourcing.
  unfunction nvm node npm npx yarn pnpm 2>/dev/null

  export NVM_DIR="$HOME/.nvm"
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

  # Auto-switch version if an .nvmrc is present in the current directory.
  [[ -f .nvmrc ]] && nvm use --silent &>/dev/null
}

_zrc_nvm_shim() {
  local cmd="$1"; shift
  _zrc_nvm_once
  # After _zrc_nvm_once: nvm is a function; node/npm/etc are binaries.
  # Plain invocation resolves both correctly.
  "$cmd" "$@"
}

nvm()  { _zrc_nvm_shim nvm  "$@"; }
node() { _zrc_nvm_shim node "$@"; }
npm()  { _zrc_nvm_shim npm  "$@"; }
npx()  { _zrc_nvm_shim npx  "$@"; }
yarn() { _zrc_nvm_shim yarn "$@"; }
pnpm() { _zrc_nvm_shim pnpm "$@"; }

# ==============================================================================
# 08) FZF WIDGETS
# ==============================================================================

# Ctrl-R: fuzzy history search.
_zrc_fzf_history() {
  local selected
  selected="$(builtin fc -rl 1 \
    | fzf --tac --no-sort --exact --height=40% --reverse --border --inline-info)"
  [[ -z "$selected" ]] && { zle reset-prompt; return; }

  BUFFER="${${selected##[[:space:]]#<->[[:space:]]#}:-$selected}"
  CURSOR=${#BUFFER}
  zle reset-prompt
}

zle -N _zrc_fzf_history
bindkey '^R' _zrc_fzf_history

# ==============================================================================
# 09) PLUGIN LOADING  (deferred — sourced after the first prompt is drawn)
# ==============================================================================

_zrc_load_plugins() {
  add-zsh-hook -d precmd _zrc_load_plugins   # Run exactly once.

  local brew='/opt/homebrew'

  local f="$brew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  if [[ -f "$f" ]]; then
    source "$f"
    ZSH_AUTOSUGGEST_STRATEGY=(history)
    ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=15
    ZSH_AUTOSUGGEST_USE_ASYNC=1
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999999,bg=default,underline'
  fi

  f="$brew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
  if [[ -f "$f" ]]; then
    source "$f"
    typeset -gA FAST_HIGHLIGHT
    FAST_HIGHLIGHT[use_async]=1
    # Remove noisy highlights that clutter normal paths.
    unset 'FAST_HIGHLIGHT_STYLES[path]' \
          'FAST_HIGHLIGHT_STYLES[path_prefix]' \
          'FAST_HIGHLIGHT_STYLES[globbing]' 2>/dev/null
  fi
}

add-zsh-hook precmd _zrc_load_plugins

# ==============================================================================
# 10) ALIASES — GENERAL
# ==============================================================================

# Config quick-edit
alias zshrc='nvim ~/.zshrc'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'

# ls
alias l='ls -lFh'
alias la='ls -lAFh'
alias ll='ls -l'

# Safer coreutils
alias cp='cp -iv'
alias mv='mv -iv'
alias mkdir='mkdir -pv'
alias rm='rm -i'
# rmd: no confirmation — intentionally named to signal "destructive remove".
alias rmd='rm -rf'

# Permissions
alias ax='chmod a+x'
alias make-exe='chmod 700'
alias symlink='ln -s'

# Utilities
alias path='echo ${(j:\n:)path}'  # Cleaner than the original tr hack.
alias please='sudo !!'

# --color=auto emits colours only to a terminal, preserving pipeline safety.
# The original `always` forced ANSI into pipes and broke grep-in-scripts.
alias grep='grep --color=auto'

# Shell introspection
alias aliases="alias | sed 's/=.*//'"
alias functions="declare -f | grep '^[a-z].* ()' | sed 's/ {$//'"

# Development linters
alias shfmt='shfmt -ci -bn -i 2'
alias sc='shellcheck --exclude=2001,2148'

# Network
alias ip='curl -s ifconfig.me'
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

# System monitoring
alias memHogs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

mine() { ps "$@" -u "${USER}" -o pid,%cpu,%mem,start,time,bsdtime,command; }

# ==============================================================================
# 11) ALIASES — DOCKER / INFRA
# ==============================================================================
# BUG FIX: the original aliases ran `cd` in the current shell, silently leaving
# you inside ~/docker/mysql after infra-up. Wrapping each in a subshell ( ... )
# keeps your working directory intact.

alias dk='docker compose'

alias kafka-up='( cd ~/docker/kafka     && dk up   -d )'
alias kafka-down='( cd ~/docker/kafka   && dk down    )'
alias redis-up='( cd ~/docker/redis     && dk up   -d )'
alias redis-down='( cd ~/docker/redis   && dk down    )'
alias pg-up='( cd ~/docker/postgres     && dk up   -d )'
alias pg-down='( cd ~/docker/postgres   && dk down    )'
alias mysql-up='( cd ~/docker/mysql     && dk up   -d )'
alias mysql-down='( cd ~/docker/mysql   && dk down    )'

alias infra-up='kafka-up && redis-up && pg-up && mysql-up'
alias infra-down='kafka-down && redis-down && pg-down && mysql-down'

alias kafka-logs='docker logs -f kafka'
alias kafka-ui-logs='docker logs -f kafka-ui'

# ==============================================================================
# 12) UTILITY FUNCTIONS
# ==============================================================================

# mkcd <dir> — create directory (including parents) and cd into it.
mkcd() { [[ -n "$1" ]] && mkdir -p "$1" && cd "$1"; }

# killproc <pattern> — preview + confirm before sending SIGTERM.
killproc() {
  [[ -z "$1" ]] && { echo 'Usage: killproc <pattern>'; return 1; }

  echo "Processes matching '$1':"
  pgrep -af -- "$1" 2>/dev/null || { echo '  (none found)'; return 1; }

  printf 'Kill all? [y/N] '
  read -r answer
  [[ "$answer" =~ ^[Yy]$ ]] && pkill -f -- "$1" && echo 'Killed.'
}

# extract <archive> — unpack any common archive format.
extract() {
  local f="$1"
  [[ -f "$f" ]] || { echo "File not found: $f"; return 1; }

  case "$f" in
    *.tar.bz2) tar xjf "$f" ;;
    *.tar.gz)  tar xzf "$f" ;;
    *.bz2)     bunzip2  "$f" ;;
    *.gz)      gunzip   "$f" ;;
    *.tar)     tar xf   "$f" ;;
    *.tbz2)    tar xjf  "$f" ;;
    *.tgz)     tar xzf  "$f" ;;
    *.zip)     unzip    "$f" ;;
    *.Z)       uncompress "$f" ;;
    *.7z)      7z x     "$f" ;;
    *)         echo "Cannot extract '$f'"; return 1 ;;
  esac
}

# dirinfo [dir] — quick summary of a directory's size and file count.
dirinfo() {
  local d="${1:-.}"
  [[ -d "$d" ]] || { echo "Not a directory: $d"; return 1; }

  echo "Directory : $d"
  echo "Size      : $(du -sh "$d" | cut -f1)"
  echo "Files     : $(find "$d" -type f | wc -l | tr -d ' ')"
  echo "Dirs      : $(find "$d" -type d | wc -l | tr -d ' ')"
}

# colors — display all 256 terminal colours with their index.
colors() {
  local i
  for i in {0..255}; do
    print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f "
    (( i % 6 == 3 )) && print
  done
}

# ==============================================================================
# 13) ALIASES — macOS
# ==============================================================================

if [[ "$OSTYPE" == darwin* ]]; then
  # Clipboard
  alias cpwd='pwd | tr -d "\n" | pbcopy'
  alias cl='fc -e - | pbcopy'
  alias caff='caffeinate -ism'

  # Screenshots — inline aliases for clipboard variants …
  alias capc='screencapture -c'
  alias capic='screencapture -i -c'
  alias capiwc='screencapture -i -w -c'

  # … and functions for timestamped file saves.
  [[ -z "${CAPTURE_FOLDER+x}" ]] && readonly CAPTURE_FOLDER="$HOME/Desktop"
  cap()   { screencapture        "$CAPTURE_FOLDER/capture-$(date +%Y%m%d_%H%M%S).png"; }
  capi()  { screencapture -i     "$CAPTURE_FOLDER/capture-$(date +%Y%m%d_%H%M%S).png"; }
  capiw() { screencapture -i -w  "$CAPTURE_FOLDER/capture-$(date +%Y%m%d_%H%M%S).png"; }

  # Finder helpers
  alias cleanDS='find . -type f -name "*.DS_Store" -ls -delete'
  alias showHidden='defaults write com.apple.finder AppleShowAllFiles TRUE'
  alias hideHidden='defaults write com.apple.finder AppleShowAllFiles FALSE'
  alias cleanupLS='/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
    -kill -r -domain local -domain system -domain user && killall Finder'

  f()  { open -a 'Finder' "${1:-.}"; }
  ql() { qlmanage -p "$@" &>/dev/null; }

  # Remove quarantine xattrs from downloaded files.
  unquarantine() {
    local attrs=(
      com.apple.metadata:kMDItemDownloadedDate
      com.apple.metadata:kMDItemWhereFroms
      com.apple.quarantine
    )
    for attr in "${attrs[@]}"; do
      xattr -r -d "$attr" "$@" 2>/dev/null
    done
  }

  # Spotlight
  alias spot-off='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
  alias spot-on='sudo launchctl load  -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
  alias spot-file="lsof -c '/mds$'"

  # BUG FIX: original had a stray `wc` suffix in the mdfind predicate string.
  spotlight() {
    [[ -z "$1" ]] && { echo 'Usage: spotlight <name>'; return 1; }
    mdfind "kMDItemDisplayName == '$1'"
  }
fi
