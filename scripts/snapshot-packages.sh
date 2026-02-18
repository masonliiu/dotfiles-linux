#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNAP_DIR="$REPO_DIR/snapshots"
mkdir -p "$SNAP_DIR"

pacman -Qqe | sort > "$SNAP_DIR/pacman-explicit.txt"
pacman -Qqem 2>/dev/null | sort > "$SNAP_DIR/aur-explicit.txt" || : > "$SNAP_DIR/aur-explicit.txt"

if command -v flatpak >/dev/null 2>&1; then
  if ! flatpak list --app --columns=application 2>/dev/null | sort > "$SNAP_DIR/flatpak-apps.txt"; then
    : > "$SNAP_DIR/flatpak-apps.txt"
  fi
else
  : > "$SNAP_DIR/flatpak-apps.txt"
fi

if command -v cargo >/dev/null 2>&1; then
  if ! cargo install --list > "$SNAP_DIR/cargo-install-list.txt" 2>/dev/null; then
    : > "$SNAP_DIR/cargo-install-list.txt"
  fi
else
  : > "$SNAP_DIR/cargo-install-list.txt"
fi

node -v > "$SNAP_DIR/node-version.txt" 2>/dev/null || : > "$SNAP_DIR/node-version.txt"
python3 --version > "$SNAP_DIR/python-version.txt" 2>/dev/null || : > "$SNAP_DIR/python-version.txt"

printf 'Updated snapshots in %s\n' "$SNAP_DIR"
