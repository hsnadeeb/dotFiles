# dotfiles

Personal dotfiles managed with symlinks.

## Structure
- `home/` -> links to `~/` (example: `home/.zshrc` -> `~/.zshrc`)
- `config/.config/` -> links to `~/.config/` (example: `config/.config/nvim` -> `~/.config/nvim`)

## Install / re-link
```bash
./install.sh
```

The installer backs up replaced files to `~/.dotfiles_backup/<timestamp>/`.
