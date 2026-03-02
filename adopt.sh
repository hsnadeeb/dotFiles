#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ "$#" -lt 1 ]; then
  echo "usage: ./adopt.sh <absolute-path-in-home> [more-paths...]"
  echo "examples: ./adopt.sh $HOME/.tmux.conf $HOME/.config/fish"
  exit 1
fi

for input in "$@"; do
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

  if [[ "$rel" == .config/* ]]; then
    target="$ROOT/home/$rel"
  else
    target="$ROOT/home/$rel"
  fi

  mkdir -p "$(dirname "$target")"

  if [ -e "$target" ] || [ -L "$target" ]; then
    echo "exists in repo: $target"
  else
    mv "$input" "$target"
    echo "moved: $input -> $target"
  fi

done

"$ROOT/install.sh"
