#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAMP="$(date +%Y%m%d_%H%M%S)"
BACKUP_DIR="$HOME/.dotfiles_backup/$STAMP"
mkdir -p "$BACKUP_DIR"

link_item() {
  local src="$1"
  local dst="$2"

  mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    local cur
    cur="$(readlink "$dst" || true)"
    if [ "$cur" = "$src" ]; then
      echo "ok: $dst"
      return 0
    fi
  fi

  if [ -e "$dst" ] || [ -L "$dst" ]; then
    local rel
    rel="${dst#$HOME/}"
    mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
    mv "$dst" "$BACKUP_DIR/$rel"
    echo "backup: $dst -> $BACKUP_DIR/$rel"
  fi

  ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

# Manage top-level dotfiles from ./home (except .config subtree)
if [ -d "$ROOT/home" ]; then
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT/home/}"
    link_item "$src" "$HOME/$rel"
  done < <(find "$ROOT/home" -mindepth 1 -maxdepth 1 ! -name '.config' -print0)
fi

# Manage ~/.config entries from ./home/.config
if [ -d "$ROOT/home/.config" ]; then
  while IFS= read -r -d '' src; do
    rel="${src#$ROOT/home/.config/}"
    link_item "$src" "$HOME/.config/$rel"
  done < <(find "$ROOT/home/.config" -mindepth 1 -maxdepth 1 -print0)
fi

# Ghostty on macOS reads from ~/Library/Application Support/com.mitchellh.ghostty/config.
# Keep it in sync with ~/.config/ghostty/config when present in this repo.
if [ -f "$ROOT/home/.config/ghostty/config" ]; then
  link_item \
    "$ROOT/home/.config/ghostty/config" \
    "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
fi

echo "done. backups in: $BACKUP_DIR"
