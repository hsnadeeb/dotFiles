# dotfiles

Personal dotfiles managed with symlinks.

## Structure
- `home/` -> links to `~/` (example: `home/.zshrc` -> `~/.zshrc`)
- `home/.config/` -> links to `~/.config/` (example: `home/.config/nvim` -> `~/.config/nvim`)

## Install / re-link
```bash
./install.sh
```

The installer backs up replaced files to `~/.dotfiles_backup/<timestamp>/`.

## macOS note
- Ghostty config is managed at `home/.config/ghostty/config`.
- Installer also links it to `~/Library/Application Support/com.mitchellh.ghostty/config`.
