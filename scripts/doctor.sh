#!/usr/bin/env bash
set -euo pipefail

pass() { printf '[PASS] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; }
fail() { printf '[FAIL] %s\n' "$1"; }

failed=0

check_cmd() {
  local cmd="$1"
  local label="$2"
  if command -v "$cmd" >/dev/null 2>&1; then
    pass "$label"
  else
    fail "$label"
    failed=1
  fi
}

echo "== Core commands =="
check_cmd git "git present"
check_cmd fish "fish present"
check_cmd nvim "nvim present"
check_cmd tmux "tmux present"
check_cmd wl-copy "wl-copy present"
check_cmd wl-paste "wl-paste present"
check_cmd grim "grim present"
check_cmd slurp "slurp present"
check_cmd wf-recorder "wf-recorder present"
check_cmd swww "swww present"
check_cmd jq "jq present"
check_cmd hyprctl "hyprctl present"
check_cmd ssh "ssh present"
check_cmd ffmpeg "ffmpeg present"
check_cmd wofi "wofi present"

echo "== Dotfile links =="
for p in \
  "$HOME/.config/hypr/hyprland.conf" \
  "$HOME/.config/hypr/theme.conf" \
  "$HOME/.config/hypr/host.conf" \
  "$HOME/.config/kitty/kitty.conf" \
  "$HOME/.tmux.conf" \
  "$HOME/.config/nvim/init.lua" \
  "$HOME/.local/bin/screenshot" \
  "$HOME/.local/bin/cliphist-picker" \
  "$HOME/.local/bin/record-screen" \
  "$HOME/.local/bin/record-screen-picker" \
  "$HOME/.local/bin/theme-switch" \
  "$HOME/.local/bin/theme-cycle"
do
  if [ -L "$p" ]; then
    pass "symlink exists: $p"
  else
    warn "not a symlink: $p"
  fi
done

echo "== Runtime checks =="
if systemctl --user is-active waybar.service >/dev/null 2>&1; then
  pass "waybar.service active"
else
  warn "waybar.service inactive"
fi

if pgrep -af 'wl-paste --type text --watch .*cliphist store' >/dev/null 2>&1 && \
   pgrep -af 'wl-paste --type image --watch .*cliphist store' >/dev/null 2>&1; then
  pass "cliphist watchers running"
else
  warn "cliphist watchers not detected (restart Hyprland session or run watchers manually)"
fi

if "$HOME/.local/bin/theme-switch" --list >/dev/null 2>&1; then
  pass "theme-switch runnable"
else
  warn "theme-switch failed"
fi

if [ -f "$HOME/.config/theme-switch/current" ]; then
  pass "current theme state file exists"
else
  warn "no current theme state file (~/.config/theme-switch/current)"
fi

if pgrep -x swww-daemon >/dev/null 2>&1; then
  pass "swww-daemon running"
else
  warn "swww-daemon not running (theme switch will start it on demand)"
fi

if nvim --headless '+qall' >/dev/null 2>&1; then
  pass "nvim headless startup"
else
  warn "nvim headless startup had warnings/errors"
fi

if timeout 5s ssh -T git@github.com >/tmp/dotfiles-doctor-ssh.log 2>&1; then
  pass "github ssh auth"
else
  if rg -q "successfully authenticated" /tmp/dotfiles-doctor-ssh.log; then
    pass "github ssh auth"
  else
    warn "github ssh auth not confirmed (network or auth issue)"
  fi
fi

if [ "$failed" -eq 0 ]; then
  echo "Doctor finished: core checks passed."
else
  echo "Doctor finished: at least one core check failed."
  exit 1
fi
