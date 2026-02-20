# dotfiles-linux

Linux-focused dotfiles for this machine.

## Includes
- `bash/.bashrc`
- `zsh/.zshrc`
- `fish/config.fish`
- `fish/conf.d/10-dev-tools.fish`
- `fish/conf.d/20-aliases.fish`
- `fish/conf.d/30-interactive.fish`
- `fish/conf.d/40-keybindings.fish`
- `starship/starship.toml`
- `git/.gitignore_global`
- `git/.gitconfig`
- `tmux/.tmux.conf`
- `hypr/hyprland.conf`
- `hypr/theme.conf`
- `host/default/hypr.conf`
- `waybar/config`
- `waybar/style.css`
- `systemd/user/waybar.service`
- `nvim/init.lua`
- `nvim/lua/*`
- `bin/cliphist-picker`
- `bin/screenshot`
- `bin/record-screen`
- `bin/record-screen-picker`
- `bin/theme-switch`
- `bin/theme-cycle`
- `ssh/config`
- `kitty/kitty.conf`
- `themes/*`

## Apply
```bash
./bootstrap.sh
git config --global core.excludesfile ~/.gitignore_global
```

## Packages (CachyOS/Arch)
```bash
./scripts/install-cachyos-core.sh
```

## Cursor IDE
```bash
./scripts/install-cursor.sh
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
  - `Super+Alt+R` recording chooser (share/quality/stop, full screen)
  - `Super+Shift+R` recording chooser (share/quality/stop, region)
  - `Super+Alt+S` stop recording
  - `Super+Shift+V` clipboard history picker
  - `Super+F1` `midnight-sapphire`
  - `Super+F2` `purple-midnight`
  - `Super+F3` `obsidian-gold`
  - `Super+F4` `deep-teal-studio`
  - `Super+F5` switch to black-white
  - `Super+F6` switch to red-city
  - `Super+Shift+F1` restore saved Waybar layout (`shift-f1-current`)
  - `Super+Shift+F2` switch to `clean-v1` Waybar layout and snapshot current layout to `shift-f1-current`
- Screenshot backend:
  - requires `grim` + `slurp` on Hyprland
- Screen recording backend:
  - requires `wf-recorder` (+ `slurp` for region)
  - profiles:
    - `share` (default): MP4, 120fps, iOS/mac compatible
    - `quality`: MKV RGB master capture (higher fidelity)
  - examples:
    - `record-screen share`
    - `record-screen quality`
    - `record-screen quality-region`
- Kitty clipboard:
  - `Ctrl+C` copy-or-interrupt
  - `Ctrl+V` paste from system clipboard
- Tmux:
  - prefix is `Ctrl+A`
- Fish:
  - vi keybindings enabled
  - autosuggestion + fzf quick insert bindings
- Waybar:
  - managed by `systemd --user` with auto-restart
  - layout presets:
    - `~/.local/bin/waybar-layout-switch --list`
    - `~/.local/bin/waybar-layout-switch clean-v1 --save-slot shift-f1-current`
    - `~/.local/bin/waybar-layout-switch shift-f1-current`
    - save slots are written under `~/.config/waybar-layout/slots/` (not tracked in git)
    - layout switch also swaps `waybar/style.css` when a matching `waybar/layouts/<name>.css` exists
- Theme switching:
  - `~/.local/bin/theme-switch --list`
  - `~/.local/bin/theme-switch <theme-name>`
  - updates: `waybar/style.css`, `wofi/style.css`, `kitty/kitty.conf`, `nvim/lua/config/theme.lua`, `~/.config/hypr/theme.conf`
  - optional wallpaper path per theme in `themes/<name>/theme.env`
  - default wallpaper filenames expected:
    - `~/Pictures/Wallpapers/midnight-sapphire.jpg`
    - `~/Pictures/Wallpapers/purple-midnight.jpg`
    - `~/Pictures/Wallpapers/obsidian-gold.jpg`
    - `~/Pictures/Wallpapers/deep-teal-studio.jpg`
    - `~/Pictures/Wallpapers/black-white.jpg`
    - `~/Pictures/Wallpapers/red-city.jpg`
- Host overrides:
  - `bootstrap.sh` links `~/.config/hypr/host.conf`
  - if `host/<hostname>/hypr.conf` exists, it is used
  - otherwise `host/default/hypr.conf` is used
  - `host/masonlegion/hypr.conf` pins Hyprland DRM device to Intel iGPU for stability
