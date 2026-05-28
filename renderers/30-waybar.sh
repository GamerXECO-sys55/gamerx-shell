#!/usr/bin/env bash
# Activate the selected Waybar style.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

bar=$(state_get bar default)
WB="$XDG_CONFIG_HOME/waybar"
mkdir -p "$WB"

src="$SYS_SHELL/waybar/styles/$bar"
[[ -d "$src" ]] || src="$SYS_SHELL/waybar/styles/default"

ln -sfn "$src/config.jsonc" "$WB/config.jsonc"
ln -sfn "$src/style.css"    "$WB/style.css"

# Hot reload Waybar
if pgrep -x waybar >/dev/null 2>&1; then
  pkill -SIGUSR2 waybar 2>/dev/null || true
fi
