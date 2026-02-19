#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"
HOST_SHORT="$(hostname -s 2>/dev/null || hostname)"

backup_file() {
  local src="$1"
  if [ -e "$src" ] || [ -L "$src" ]; then
    mkdir -p "$HOME/.dotfiles-backup/$TS"
    mv "$src" "$HOME/.dotfiles-backup/$TS/"
  fi
}

link_file() {
  local source_file="$1"
  local target_file="$2"
  backup_file "$target_file"
  mkdir -p "$(dirname "$target_file")"
  ln -s "$source_file" "$target_file"
}

link_file "$REPO_DIR/bash/.bashrc" "$HOME/.bashrc"
link_file "$REPO_DIR/zsh/.zshrc" "$HOME/.zshrc"
link_file "$REPO_DIR/fish/config.fish" "$HOME/.config/fish/config.fish"
link_file "$REPO_DIR/fish/fish_plugins" "$HOME/.config/fish/fish_plugins"
link_file "$REPO_DIR/fish/conf.d/10-dev-tools.fish" "$HOME/.config/fish/conf.d/10-dev-tools.fish"
link_file "$REPO_DIR/fish/conf.d/20-aliases.fish" "$HOME/.config/fish/conf.d/20-aliases.fish"
link_file "$REPO_DIR/fish/conf.d/30-interactive.fish" "$HOME/.config/fish/conf.d/30-interactive.fish"
link_file "$REPO_DIR/fish/conf.d/40-keybindings.fish" "$HOME/.config/fish/conf.d/40-keybindings.fish"
link_file "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
link_file "$REPO_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$REPO_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
link_file "$REPO_DIR/hypr/theme.conf" "$HOME/.config/hypr/theme.conf"
if [ -f "$REPO_DIR/host/$HOST_SHORT/hypr.conf" ]; then
  link_file "$REPO_DIR/host/$HOST_SHORT/hypr.conf" "$HOME/.config/hypr/host.conf"
else
  link_file "$REPO_DIR/host/default/hypr.conf" "$HOME/.config/hypr/host.conf"
fi
link_file "$REPO_DIR/waybar" "$HOME/.config/waybar"
link_file "$REPO_DIR/systemd/user/waybar.service" "$HOME/.config/systemd/user/waybar.service"
link_file "$REPO_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_file "$REPO_DIR/nvim/lua" "$HOME/.config/nvim/lua"
link_file "$REPO_DIR/bin/cliphist-picker" "$HOME/.local/bin/cliphist-picker"
link_file "$REPO_DIR/bin/screenshot" "$HOME/.local/bin/screenshot"
link_file "$REPO_DIR/bin/record-screen" "$HOME/.local/bin/record-screen"
link_file "$REPO_DIR/bin/record-screen-picker" "$HOME/.local/bin/record-screen-picker"
link_file "$REPO_DIR/bin/theme-switch" "$HOME/.local/bin/theme-switch"
link_file "$REPO_DIR/bin/theme-cycle" "$HOME/.local/bin/theme-cycle"
link_file "$REPO_DIR/ssh/config" "$HOME/.ssh/config"
link_file "$REPO_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

systemctl --user daemon-reload >/dev/null 2>&1 || true
systemctl --user enable --now waybar.service >/dev/null 2>&1 || true

echo "Dotfiles linked. Backups (if any): $HOME/.dotfiles-backup/$TS"
echo "Set global gitignore: git config --global core.excludesfile ~/.gitignore_global"
