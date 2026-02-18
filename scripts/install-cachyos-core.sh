#!/usr/bin/env bash
set -euo pipefail

# System packages (requires sudo privileges)
# Includes terminal quality-of-life tools and tmux.
sudo pacman -S --needed --noconfirm \
  tmux \
  eza \
  bat \
  fd \
  jq \
  grim \
  slurp \
  wl-clipboard \
  github-cli

# Optional AUR packages
if command -v yay >/dev/null 2>&1; then
  yay -S --needed --noconfirm \
    visual-studio-code-bin
fi
