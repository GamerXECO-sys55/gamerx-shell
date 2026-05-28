#!/usr/bin/env bash
# Apply the configured wallpaper via swww.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

wp=$(state_get wallpaper /usr/share/gamerx/wallpapers/default/01-aurora-3840x2160.svg)

# Stash a stable path for hyprlock and others to read.
ln -sfn "$wp" "$GAMERX_DIR/wallpaper-current"

if command -v swww >/dev/null 2>&1 && pgrep -x swww-daemon >/dev/null 2>&1; then
  swww img "$wp" --transition-type any --transition-duration 1.2 >/dev/null 2>&1 || true
fi
