#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0
STAMP="$(date +%Y%m%d_%H%M%S)"
CONFLICT_DIR="$ROOT/.adopt_conflicts/$STAMP"
CONFLICT_READY=0

usage() {
  cat <<EOF
usage: ./adopt.sh [--dry-run] <absolute-path-in-home> [more-paths...]
examples:
  ./adopt.sh \$HOME/.tmux.conf \$HOME/.config/fish
  ./adopt.sh --dry-run \$HOME/.zshrc
EOF
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "dry-run: $*"
  else
    "$@"
  fi
}

ensure_conflict_dir() {
  [ "$CONFLICT_READY" -eq 1 ] && return 0
  run mkdir -p "$CONFLICT_DIR"
  CONFLICT_READY=1
}

inputs=()
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *) inputs+=("$arg") ;;
  esac
done

if [ "${#inputs[@]}" -lt 1 ]; then
  usage
  exit 1
fi

for input in "${inputs[@]}"; do
  case "$input" in
    "$HOME"/*) ;;
    *)
      echo "skip: $input (must be under $HOME)"
      continue
      ;;
  esac

  if [ ! -e "$input" ] && [ ! -L "$input" ]; then
    echo "skip: $input (not found)"
    continue
  fi

  rel="${input#$HOME/}"
  target="$ROOT/home/$rel"

  run mkdir -p "$(dirname "$target")"

  if [ -e "$target" ] || [ -L "$target" ]; then
    ensure_conflict_dir
    safe_rel="${rel//\//__}"
    backup_target="$CONFLICT_DIR/$safe_rel"
    run mv "$target" "$backup_target"
    echo "conflict backup: $target -> $backup_target"
  else
    :
  fi

  run mv "$input" "$target"
  echo "moved: $input -> $target"
done

if [ "$DRY_RUN" -eq 1 ]; then
  "$ROOT/install.sh" --dry-run
else
  "$ROOT/install.sh"
fi
