#!/usr/bin/env bash
# Apply the active palette to hyprlock.conf.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

dst="$XDG_CONFIG_HOME/hypr/hyprlock.conf"
mkdir -p "$(dirname "$dst")"

# Read the merged theme JSON (10-palette wrote it).
[[ -f "$THEME_JSON" ]] || exit 0
read_json() { python3 -c "import json; print(json.load(open('$THEME_JSON'))['$1'])"; }

bg=$(read_json bg)
fg=$(read_json fg)
fg_dim=$(read_json fgDim)
accent=$(read_json accent)
highlight=$(read_json highlight)
border=$(read_json border)
warn=$(read_json warn)
error=$(read_json error)
success=$(read_json success)

# Helper: hex (#RRGGBB) -> rgba(R,G,B,A)
hex2rgba() {
  local h="${1#\#}" a="${2:-1.0}"
  printf 'rgba(%d, %d, %d, %s)' "$((16#${h:0:2}))" "$((16#${h:2:2}))" "$((16#${h:4:2}))" "$a"
}

# Render hyprlock.conf from template
sed -e "s|__GX_BG__|$(hex2rgba "$bg" 0.85)|g" \
    -e "s|__GX_FG__|$(hex2rgba "$fg" 1.0)|g" \
    -e "s|__GX_FG_DIM__|$(hex2rgba "$fg_dim" 1.0)|g" \
    -e "s|__GX_ACCENT__|$(hex2rgba "$accent" 1.0)|g" \
    -e "s|__GX_HIGHLIGHT__|$(hex2rgba "$highlight" 1.0)|g" \
    -e "s|__GX_BORDER__|$(hex2rgba "$border" 1.0)|g" \
    -e "s|__GX_WARN__|$(hex2rgba "$warn" 1.0)|g" \
    -e "s|__GX_ERROR__|$(hex2rgba "$error" 1.0)|g" \
    -e "s|__GX_SUCCESS__|$(hex2rgba "$success" 1.0)|g" \
    "$SYS_SHELL/hyprlock/hyprlock.conf" > "$dst"
