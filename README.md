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
- `hypr/hyprland.conf`
- `nvim/init.lua`
- `nvim/lua/*`
- `bin/cliphist-picker`
- `bin/screenshot`
- `ssh/config`
- `kitty/kitty.conf`

## Apply
```bash
./bootstrap.sh
git config --global core.excludesfile ~/.gitignore_global
```

## Packages (CachyOS/Arch)
```bash
./scripts/install-cachyos-core.sh
```

## Restore
```bash
./scripts/restore.sh
```

## Verify
```bash
./scripts/doctor.sh
```

## Package Snapshot
```bash
./scripts/snapshot-packages.sh
```
- writes package/state files into `snapshots/`

## Notes
- Installs links with backup to `~/.dotfiles-backup/<timestamp>`.
- Hyprland binds:
  - `Print` full screenshot
  - `Shift+Print` region screenshot
  - `Super+Print` active window screenshot
  - `Super+Shift+V` clipboard history picker
- Screenshot backend:
  - requires `grim` + `slurp` on Hyprland
- Kitty clipboard:
  - `Ctrl+C` copy-or-interrupt
  - `Ctrl+V` paste from system clipboard
