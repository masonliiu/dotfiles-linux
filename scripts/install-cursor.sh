#!/usr/bin/env bash
set -euo pipefail

install_root="$HOME/.local/opt/cursor"
mkdir -p "$install_root" "$HOME/.local/bin" "$HOME/.local/share/applications"

url="https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/2.5"
curl -fL "$url" -o "$install_root/Cursor.AppImage"
chmod +x "$install_root/Cursor.AppImage"

cd "$install_root"
rm -rf squashfs-root cursor-appdir
./Cursor.AppImage --appimage-extract >/dev/null 2>&1
mv squashfs-root cursor-appdir

cat > "$HOME/.local/bin/cursor" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
APPDIR="$HOME/.local/opt/cursor/cursor-appdir"
exec env APPDIR="$APPDIR" "$APPDIR/AppRun" "$@"
EOS

cat > "$HOME/.local/bin/cursor-x11" <<'EOS'
#!/usr/bin/env bash
set -euo pipefail
APPDIR="$HOME/.local/opt/cursor/cursor-appdir"
SCALE="${CURSOR_SCALE:-}"
if [ -z "$SCALE" ] && command -v hyprctl >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
  SCALE="$(hyprctl -j monitors | jq -r '.[] | select(.focused==true) | .scale' | head -n1)"
fi
SCALE="${SCALE:-1}"
exec env APPDIR="$APPDIR" QT_QPA_PLATFORM=xcb "$APPDIR/AppRun" \
  --force-device-scale-factor="$SCALE" "$@"
EOS

chmod +x "$HOME/.local/bin/cursor" "$HOME/.local/bin/cursor-x11"

cat > "$HOME/.local/share/applications/cursor.desktop" <<'EOS'
[Desktop Entry]
Type=Application
Name=Cursor
Comment=AI code editor
Exec=/home/mason/.local/bin/cursor-x11 %F
Terminal=false
Categories=Development;IDE;TextEditor;
StartupNotify=true
EOS

echo "Cursor installed. Launch with: ~/.local/bin/cursor-x11"
