#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup/$STAMP"
DRY_RUN=0
NO_BACKUP=0
BACKUP_READY=0

usage() {
  cat <<'EOF'
usage: ./install.sh [--dry-run] [--no-backup]

options:
  --dry-run    Show what would change without modifying files.
  --no-backup  Replace existing targets without moving them to backup.
  -h, --help   Show this help.
EOF
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --no-backup) NO_BACKUP=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown option: $arg" >&2
      usage >&2
      exit 1
      ;;
  esac
done

log() { printf '%s\n' "$*"; }

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    log "dry-run: $*"
  else
    "$@"
  fi
}

ensure_backup_dir() {
  [ "$BACKUP_READY" -eq 1 ] && return 0
  run mkdir -p "$BACKUP_DIR"
  BACKUP_READY=1
}

link_item() {
  local src="$1"
  local dst="$2"

  run mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [ "$cur" = "$src" ]; then
      log "ok: $dst"
      return 0
    fi
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$NO_BACKUP" -eq 1 ]; then
      run rm -rf "$dst"
      log "replace: $dst"
    else
      local rel
      rel="${dst#$HOME/}"
      ensure_backup_dir
      run mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      run mv "$dst" "$BACKUP_DIR/$rel"
      log "backup: $dst -> $BACKUP_DIR/$rel"
    fi
  fi

  run ln -s "$src" "$dst"
  log "link: $dst -> $src"
}

# Manage top-level dotfiles from ./home (except .config subtree)
if [ -d "$ROOT/home" ]; then
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT/home/}"
    link_item "$src" "$HOME/$rel"
  done < <(find "$ROOT/home" -mindepth 1 -maxdepth 1 ! -name '.config' -print0 | sort -z)
fi

# Manage ~/.config entries from ./home/.config
if [ -d "$ROOT/home/.config" ]; then
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT/home/.config/}"
    link_item "$src" "$HOME/.config/$rel"
  done < <(find "$ROOT/home/.config" -mindepth 1 -maxdepth 1 -print0 | sort -z)
fi

# Ghostty on macOS reads from ~/Library/Application Support/com.mitchellh.ghostty/config.
# Keep it in sync with ~/.config/ghostty/config when present in this repo.
if [ -f "$ROOT/home/.config/ghostty/config" ]; then
  link_item \
    "$ROOT/home/.config/ghostty/config" \
    "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
fi

if [ "$NO_BACKUP" -eq 1 ]; then
  log "done. backup disabled (--no-backup)."
elif [ "$BACKUP_READY" -eq 1 ]; then
  log "done. backups in: $BACKUP_DIR"
else
  log "done. no backups were needed."
fi
