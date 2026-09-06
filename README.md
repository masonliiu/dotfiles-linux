# dotfiles-linux

Portable Linux dotfiles for Hyprland machines.

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
- `hypr/hyprland.lua` (primary Hyprland 0.55+ config)
- `hypr/hyprland.conf` (legacy fallback)
- `hypr/theme.lua` and `hypr/theme.conf` (Lua + legacy theme bridges)
- `host/default/hypr.lua` and `host/default/hypr.conf`
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
- `bin/toggle-monitor-mode`
- `bin/toggle-lid-sleep`
- `bin/gammastep-toggle`
- `ssh/config`
- `kitty/kitty.conf`
- `themes/*`

## Apply
```bash
./bootstrap.sh
git config --global core.excludesfile ~/.gitignore_global
```

`bootstrap.sh` links both Hyprland config formats. On Hyprland 0.55 and newer,
`hyprland.lua` is loaded and the host-specific `host.lua` supplies monitor
layouts. The old `.conf` files remain linked so you can roll back or use an
older Hyprland release. The script uses `$HOME` and the detected hostname, so
the same checkout can be used by a different Linux user or on the Asahi Mac.

## Packages (CachyOS/Arch)
```bash
./scripts/install-cachyos-core.sh
```

That package helper is CachyOS-specific; do not run it on the Asahi Mac. Install
the equivalent Arch/Asahi packages there, then run `./bootstrap.sh`.

## Cursor IDE
```bash
./scripts/install-cursor.sh
```

## Restore
```bash
./scripts/restore.sh
```

`restore.sh` is a CachyOS-oriented convenience wrapper. On Asahi/Arch, use
`./bootstrap.sh` directly and install only the packages you need.

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
- Maintenance:
  - run on demand: `~/.local/bin/dotfiles-maintenance`
  - weekly timer: `dotfiles-maintenance.timer` (Sunday 10:00, persistent)
- Theme switching:
  - `~/.local/bin/theme-switch --list`
  - `~/.local/bin/theme-switch <theme-name>`
  - updates: `waybar/style.css`, `kitty/kitty.conf`, `nvim/lua/config/theme.lua`, and `~/.config/hypr/theme.conf`; the active Hyprland config is reloaded, and Lua reads the shared theme state
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
  - it also links `~/.config/hypr/host.lua`
  - if `host/<hostname>/hypr.lua`/`.conf` exists, it is used
  - otherwise the generic preferred-monitor host files are used
  - `host/masonlegion` contains this machine's external-display layout
