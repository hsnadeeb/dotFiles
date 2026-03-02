# ~/.config/fish/config.fish
# Fish-native config modeled after /Users/shaz/dotfiles/home/.zshrc

# -----------------------------------------------------------------------------
# 01) Environment and PATH
# -----------------------------------------------------------------------------

function __zrc_path_prepend --argument dir
    if test -n "$dir"; and test -d "$dir"
        fish_add_path -g -p "$dir"
    end
end

set -gx HISTFILE "$HOME/.zsh_history"

__zrc_path_prepend "/Applications/IntelliJ IDEA.app/Contents/MacOS"
__zrc_path_prepend "/opt/homebrew/bin"
__zrc_path_prepend "/usr/local/bin"
__zrc_path_prepend "$HOME/go/bin"
__zrc_path_prepend "$HOME/.local/bin"
__zrc_path_prepend "$HOME/.jenv/bin"
__zrc_path_prepend "$HOME/.codeium/windsurf/bin"

if set -q JAVA_HOME
    __zrc_path_prepend "$JAVA_HOME/bin"
end

if set -q ANDROID_HOME
    __zrc_path_prepend "$ANDROID_HOME/platform-tools"
    __zrc_path_prepend "$ANDROID_HOME/emulator"
    __zrc_path_prepend "$ANDROID_HOME/tools/bin"
    __zrc_path_prepend "$ANDROID_HOME/tools"
end

if not status is-interactive
    exit
end

# -----------------------------------------------------------------------------
# 02) Interactive behavior
# -----------------------------------------------------------------------------

set -g fish_greeting ""
stty -ixon 2>/dev/null

bind \e\[A history-prefix-search-backward
bind \e\[B history-prefix-search-forward

# -----------------------------------------------------------------------------
# 03) Prompt (git branch + dirty marker + exit code + extra spacing)
# -----------------------------------------------------------------------------

function __zrc_git_info
    command -sq git; or return
    git rev-parse --is-inside-work-tree >/dev/null 2>&1; or return

    set -l branch (git symbolic-ref --quiet --short HEAD 2>/dev/null)
    if test -z "$branch"
        set branch (git rev-parse --short HEAD 2>/dev/null)
    end
    test -z "$branch"; and return

    set -l dirty ""
    if test -n "$(git status --porcelain -uno 2>/dev/null)"
        set dirty " "(set_color brred)"✚"(set_color normal)
    end

    echo -n " "(set_color brblack)"on"(set_color normal)" "(set_color green)$branch(set_color normal)$dirty
end

function fish_prompt
    set -l last_status $status

    echo

    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n $USER
    set_color normal

    echo -n " "
    set_color brblack
    echo -n "in"
    set_color normal
    echo -n " "
    set_color brcyan
    echo -n (prompt_pwd)
    set_color normal

    echo -n (__zrc_git_info)

    if test $last_status -ne 0
        echo -n " "
        set_color red
        echo -n "✘ $last_status"
        set_color normal
    end

    echo
    set_color red
    echo -n "❯ "
    set_color normal
end

# -----------------------------------------------------------------------------
# 04) Mise lazy init
# -----------------------------------------------------------------------------

set -g __zrc_mise_loaded 0

function __zrc_load_mise_once
    if test $__zrc_mise_loaded -eq 1
        return
    end
    command -sq mise; or return

    set -g __zrc_mise_loaded 1
    mise activate fish | source
end

function __zrc_mise_on_pwd --on-variable PWD
    __zrc_load_mise_once
end

function __zrc_mise_on_prompt --on-event fish_prompt
    __zrc_load_mise_once
end

function mise
    __zrc_load_mise_once
    command mise $argv
end

# -----------------------------------------------------------------------------
# 05) Aliases and helpers
# -----------------------------------------------------------------------------

alias zshrc='nvim ~/.zshrc'
alias fishrc='nvim ~/.config/fish/config.fish'

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
alias shfmt='shfmt -ci -bn -i 2'
alias sc='shellcheck --exclude=2001,2148'
alias grep='grep --color=auto'

function path
    string split : $PATH
end

function please
    set -l last_cmd (history --max=1)
    if test -z "$last_cmd"
        echo "No command in history."
        return 1
    end
    eval sudo $last_cmd
end

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
alias projects='cd ~/Projects; and la'
alias nvconf='cd ~/.config/nvim'
alias wello='cd ~/Projects/Wello; and la'
alias shaz='cd ~/Projects/Shaz; and la'
alias notes='cd ~/Projects/Learning/VSCodeNotes; and nvim .'
alias be='cd ~/Projects/Wello/vital-ecare-backend; and npm run dev'
alias fe='cd ~/Projects/Wello/vital-ecare-frontend; and npm start'
alias x3rph='cd ~/oracle/X3rph; and ssh -i x3rph.key ubuntu@161.118.167.226'
alias doom='cd ~/Projects/Games/terminal-doom; and ./zig-out/bin/terminal-doom'

# System monitoring
alias memHogs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

function mine
    ps $argv -u "$USER" -o pid,%cpu,%mem,start,time,bsdtime,command
end

# Docker / infra
alias dk='docker compose'

function kafka-up
    set -l oldpwd $PWD
    cd ~/docker/kafka; and dk up -d
    set -l rc $status
    cd $oldpwd
    return $rc
end

function kafka-down
    set -l oldpwd $PWD
    cd ~/docker/kafka; and dk down
    set -l rc $status
    cd $oldpwd
    return $rc
end

function redis-up
    set -l oldpwd $PWD
    cd ~/docker/redis; and dk up -d
    set -l rc $status
    cd $oldpwd
    return $rc
end

function redis-down
    set -l oldpwd $PWD
    cd ~/docker/redis; and dk down
    set -l rc $status
    cd $oldpwd
    return $rc
end

function pg-up
    set -l oldpwd $PWD
    cd ~/docker/postgres; and dk up -d
    set -l rc $status
    cd $oldpwd
    return $rc
end

function pg-down
    set -l oldpwd $PWD
    cd ~/docker/postgres; and dk down
    set -l rc $status
    cd $oldpwd
    return $rc
end

function mysql-up
    set -l oldpwd $PWD
    cd ~/docker/mysql; and dk up -d
    set -l rc $status
    cd $oldpwd
    return $rc
end

function mysql-down
    set -l oldpwd $PWD
    cd ~/docker/mysql; and dk down
    set -l rc $status
    cd $oldpwd
    return $rc
end

function infra-up
    kafka-up; and redis-up; and pg-up; and mysql-up
end

function infra-down
    kafka-down; and redis-down; and pg-down; and mysql-down
end

alias kafka-logs='docker logs -f kafka'
alias kafka-ui-logs='docker logs -f kafka-ui'

# Utility functions
function mkcd
    if test -z "$argv[1]"
        echo "Usage: mkcd <dir>"
        return 1
    end
    mkdir -p "$argv[1]"; and cd "$argv[1]"
end

function killproc
    if test -z "$argv[1]"
        echo "Usage: killproc <pattern>"
        return 1
    end

    echo "Processes matching '$argv[1]':"
    pgrep -af -- "$argv[1]"; or begin
        echo "  (none found)"
        return 1
    end

    read -P "Kill all? [y/N] " answer
    if string match -rq '^[Yy]$' -- "$answer"
        pkill -f -- "$argv[1]"; and echo "Killed."
    end
end

function extract --argument f
    if not test -f "$f"
        echo "File not found: $f"
        return 1
    end

    switch "$f"
        case '*.tar.bz2'
            tar xjf "$f"
        case '*.tar.gz'
            tar xzf "$f"
        case '*.bz2'
            bunzip2 "$f"
        case '*.gz'
            gunzip "$f"
        case '*.tar'
            tar xf "$f"
        case '*.tbz2'
            tar xjf "$f"
        case '*.tgz'
            tar xzf "$f"
        case '*.zip'
            unzip "$f"
        case '*.Z'
            uncompress "$f"
        case '*.7z'
            7z x "$f"
        case '*'
            echo "Cannot extract '$f'"
            return 1
    end
end

function dirinfo
    set -l d "."
    if test -n "$argv[1]"
        set d "$argv[1]"
    end

    if not test -d "$d"
        echo "Not a directory: $d"
        return 1
    end

    echo "Directory : $d"
    echo "Size      : "(du -sh "$d" | cut -f1)
    echo "Files     : "(find "$d" -type f | wc -l | string trim)
    echo "Dirs      : "(find "$d" -type d | wc -l | string trim)
end

function colors
    for i in (seq 0 255)
        set_color --background=$i
        echo -n "  "
        set_color normal
        printf "%03d " $i
        if test (math "$i % 6") -eq 3
            echo
        end
    end
    echo
end

# macOS-specific helpers
if test (uname) = "Darwin"
    alias cpwd='pwd | tr -d "\n" | pbcopy'
    alias cl='history --max=1 | pbcopy'
    alias caff='caffeinate -ism'

    alias capc='screencapture -c'
    alias capic='screencapture -i -c'
    alias capiwc='screencapture -i -w -c'

    function cap
        screencapture "$HOME/Desktop/capture-"(date +%Y%m%d_%H%M%S)".png"
    end

    function capi
        screencapture -i "$HOME/Desktop/capture-"(date +%Y%m%d_%H%M%S)".png"
    end

    function capiw
        screencapture -i -w "$HOME/Desktop/capture-"(date +%Y%m%d_%H%M%S)".png"
    end

    alias cleanDS='find . -type f -name "*.DS_Store" -ls -delete'
    alias showHidden='defaults write com.apple.finder AppleShowAllFiles TRUE'
    alias hideHidden='defaults write com.apple.finder AppleShowAllFiles FALSE'

    function cleanupLS
        /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister \
            -kill -r -domain local -domain system -domain user
        and killall Finder
    end

    function f
        if test -n "$argv[1]"
            open -a Finder "$argv[1]"
        else
            open -a Finder .
        end
    end

    function ql
        qlmanage -p $argv >/dev/null 2>&1
    end

    function unquarantine
        set -l attrs \
            com.apple.metadata:kMDItemDownloadedDate \
            com.apple.metadata:kMDItemWhereFroms \
            com.apple.quarantine
        for attr in $attrs
            xattr -r -d "$attr" $argv 2>/dev/null
        end
    end

    alias spot-off='sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
    alias spot-on='sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist'
    function spot-file
        lsof -c '/mds$' $argv
    end

    function spotlight
        if test -z "$argv[1]"
            echo "Usage: spotlight <name>"
            return 1
        end
        mdfind "kMDItemDisplayName == '$argv[1]'"
    end
end
