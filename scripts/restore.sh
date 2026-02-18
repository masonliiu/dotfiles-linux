#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO_DIR"

echo "[1/4] Linking dotfiles"
./bootstrap.sh

echo "[2/4] Installing CachyOS core packages"
./scripts/install-cachyos-core.sh

echo "[3/4] Capturing package snapshot"
./scripts/snapshot-packages.sh

echo "[4/4] Running doctor checks"
./scripts/doctor.sh

echo "Restore complete."
