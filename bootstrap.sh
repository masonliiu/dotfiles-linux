#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

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
link_file "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO_DIR/git/.gitignore_global" "$HOME/.gitignore_global"
link_file "$REPO_DIR/git/.gitconfig" "$HOME/.gitconfig"
link_file "$REPO_DIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_file "$REPO_DIR/hypr/hyprland.conf" "$HOME/.config/hypr/hyprland.conf"
link_file "$REPO_DIR/nvim/init.lua" "$HOME/.config/nvim/init.lua"
link_file "$REPO_DIR/nvim/lua" "$HOME/.config/nvim/lua"
link_file "$REPO_DIR/bin/cliphist-picker" "$HOME/.local/bin/cliphist-picker"
link_file "$REPO_DIR/bin/screenshot" "$HOME/.local/bin/screenshot"
link_file "$REPO_DIR/ssh/config" "$HOME/.ssh/config"
link_file "$REPO_DIR/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

echo "Dotfiles linked. Backups (if any): $HOME/.dotfiles-backup/$TS"
echo "Set global gitignore: git config --global core.excludesfile ~/.gitignore_global"
