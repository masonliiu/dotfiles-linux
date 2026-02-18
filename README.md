# dotfiles-linux

Linux-focused dotfiles for this machine.

## Includes
- `bash/.bashrc`
- `zsh/.zshrc`
- `fish/config.fish`
- `fish/conf.d/10-dev-tools.fish`
- `starship/starship.toml`
- `git/.gitignore_global`

## Apply
```bash
./bootstrap.sh
git config --global core.excludesfile ~/.gitignore_global
```

## Notes
- Installs links with backup to `~/.dotfiles-backup/<timestamp>`.
- This repo intentionally tracks Linux shell and prompt setup first.
