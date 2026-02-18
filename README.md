# dotfiles-linux

Linux-focused dotfiles for this machine.

## Includes
- `bash/.bashrc`
- `zsh/.zshrc`
- `fish/config.fish`
- `fish/conf.d/10-dev-tools.fish`
- `fish/conf.d/20-aliases.fish`
- `starship/starship.toml`
- `git/.gitignore_global`
- `git/.gitconfig`
- `tmux/.tmux.conf`

## Apply
```bash
./bootstrap.sh
git config --global core.excludesfile ~/.gitignore_global
```

## Packages (CachyOS/Arch)
```bash
./scripts/install-cachyos-core.sh
```

## Notes
- Installs links with backup to `~/.dotfiles-backup/<timestamp>`.
- This repo intentionally tracks Linux shell and prompt setup first.
