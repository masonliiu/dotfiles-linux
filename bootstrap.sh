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
link_file "$REPO_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
link_file "$REPO_DIR/git/.gitignore_global" "$HOME/.gitignore_global"

echo "Dotfiles linked. Backups (if any): $HOME/.dotfiles-backup/$TS"
echo "Set global gitignore: git config --global core.excludesfile ~/.gitignore_global"
