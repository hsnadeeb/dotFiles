# dotfiles

Personal development dotfiles, installed via symlinks from this repo into your home directory.

## What this repo does
- Keeps shell/editor/terminal config in version control.
- Symlinks files from `home/` into `~/`.
- Symlinks entries from `home/.config/` into `~/.config/`.
- On macOS, also links Ghostty config to:
  `~/Library/Application Support/com.mitchellh.ghostty/config`

## Repo layout
- `home/.zshrc` -> `~/.zshrc`
- `home/.p10k.zsh` -> `~/.p10k.zsh`
- `home/.config/*` -> `~/.config/*`
- `install.sh` -> create/refresh symlinks
- `adopt.sh` -> move existing local files into this repo, then relink

## Prerequisites (new machine)
Install these before running `./install.sh` so your shell starts cleanly.

1. Install Homebrew (if missing).
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

2. Install required CLI + zsh prompt/plugins.
```bash
brew install git curl zsh zsh-autosuggestions zsh-fast-syntax-highlighting fzf
```

3. Install Powerlevel10k to the path expected by `home/.zshrc`.
```bash
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
```

4. Install optional runtime manager used by `.zshrc`.
```bash
brew install mise
```

5. Enable `fzf` shell integration (recommended).
```bash
"$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc
```

6. Ensure Powerlevel10k theme path exists (used by `.zshrc`).
```bash
ls -la ~/powerlevel10k/powerlevel10k.zsh-theme
```

7. Optional tools referenced by aliases/functions.
```bash
brew install neovim ripgrep fd eza shellcheck shfmt lazygit
```

8. Optional infra/archive tools used by some aliases/functions.
```bash
brew install docker docker-compose unzip p7zip
```

## New computer setup (macOS)
1. Clone the repo.
```bash
git clone <your-repo-url> ~/dotfiles
cd ~/dotfiles
```

2. Preview changes first (safe dry run).
```bash
./install.sh --dry-run
```

3. Apply symlinks.
```bash
./install.sh
```

4. Reload shell config.
```bash
exec zsh
```

5. Verify links.
```bash
ls -la ~/.zshrc ~/.p10k.zsh
ls -la ~/.config
```

## Backup and safety behavior
- By default, existing target files are moved to:
  `~/.dotfiles_backup/<timestamp>/`
- If nothing needs replacement, no backup directory is created.
- To replace without backups:
```bash
./install.sh --no-backup
```

## Adopt existing local config into this repo
Use this when you already have local files and want to start managing them from dotfiles.

1. Preview:
```bash
./adopt.sh --dry-run "$HOME/.tmux.conf" "$HOME/.config/fish"
```

2. Run for real:
```bash
./adopt.sh "$HOME/.tmux.conf" "$HOME/.config/fish"
```

Notes:
- Inputs must be absolute paths under `$HOME`.
- If a target already exists in the repo, it is moved to:
  `.adopt_conflicts/<timestamp>/`

## Day-to-day usage
- Re-apply links after pulling updates:
```bash
./install.sh
```
- Preview before changes:
```bash
./install.sh --dry-run
```
