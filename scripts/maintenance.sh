#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WARNED=0

pass() { printf '[PASS] %s\n' "$1"; }
warn() { printf '[WARN] %s\n' "$1"; WARNED=1; }
info() { printf '[INFO] %s\n' "$1"; }

echo "== Dotfiles Maintenance =="
echo "Date: $(date -Is)"
echo

echo "== Doctor =="
if "$REPO_DIR/scripts/doctor.sh"; then
  pass "doctor completed"
else
  warn "doctor reported issues"
fi
echo

echo "== Service Health =="
if systemctl is-active --quiet NetworkManager; then
  pass "NetworkManager active"
else
  warn "NetworkManager inactive"
fi

if systemctl is-active --quiet bluetooth; then
  pass "bluetooth active"
else
  warn "bluetooth inactive"
fi

if systemctl --user is-active --quiet waybar.service; then
  pass "waybar.service active"
else
  warn "waybar.service inactive"
fi
echo

echo "== Wi-Fi Profiles =="
if command -v nmcli >/dev/null 2>&1; then
  mapfile -t wifi_profiles < <(nmcli -t -f NAME,TYPE,AUTOCONNECT connection show | awk -F: '$2=="802-11-wireless"{print}')
  if [[ ${#wifi_profiles[@]} -eq 0 ]]; then
    warn "no saved Wi-Fi profiles"
  else
    for row in "${wifi_profiles[@]}"; do
      IFS=':' read -r name _ autoconnect <<<"$row"
      if [[ "$autoconnect" == "yes" ]]; then
        pass "autoconnect enabled: $name"
      else
        warn "autoconnect disabled: $name"
      fi
    done
  fi
else
  warn "nmcli not found"
fi
echo

echo "== Disk Health =="
check_disk() {
  local mount="$1"
  local used
  used="$(df -P "$mount" | awk 'NR==2{gsub("%","",$5); print $5}')"
  if [[ -z "$used" ]]; then
    warn "unable to read disk usage for $mount"
    return
  fi
  if (( used >= 90 )); then
    warn "$mount usage high: ${used}%"
  elif (( used >= 80 )); then
    warn "$mount usage elevated: ${used}%"
  else
    pass "$mount usage healthy: ${used}%"
  fi
}

check_disk /
check_disk /home
echo

echo "== Waybar Polling =="
if command -v jq >/dev/null 2>&1; then
  mapfile -t fast_modules < <(
    jq -r '
      to_entries[]
      | select(.value|type=="object" and has("interval"))
      | select(.value.interval < 2)
      | "\(.key)=\(.value.interval)"' "$REPO_DIR/waybar/config"
  )
  if [[ ${#fast_modules[@]} -eq 0 ]]; then
    pass "no sub-2s polling intervals in waybar config"
  else
    warn "fast polling modules detected:"
    for module in "${fast_modules[@]}"; do
      info "  $module"
    done
  fi
else
  warn "jq not found, cannot inspect waybar polling intervals"
fi
echo

echo "== Repo State =="
if git -C "$REPO_DIR" diff --quiet && git -C "$REPO_DIR" diff --cached --quiet; then
  pass "dotfiles repo has no unstaged/staged changes"
else
  warn "dotfiles repo has local changes"
fi

if [[ -d "$HOME/.ssh" ]]; then
  pass "~/.ssh exists"
else
  warn "~/.ssh missing"
fi
echo

if [[ "$WARNED" -eq 0 ]]; then
  echo "Maintenance finished clean."
else
  echo "Maintenance finished with warnings."
fi
