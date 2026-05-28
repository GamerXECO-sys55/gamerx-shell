#!/usr/bin/env bash
# Shared helpers for gamerx-theme renderers.
# Each renderer lives in /usr/share/gamerx-theme/renderers/ and is a plain shell
# script that reads from $STATE and $PALETTE_FILE and writes to $USER_CFG.
set -euo pipefail

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

GAMERX_DIR="$XDG_CONFIG_HOME/gamerx"
STATE="$GAMERX_DIR/state.toml"
USER_CFG="$XDG_CONFIG_HOME"
SYS_SHELL="/usr/share/gamerx-shell"
SYS_PALETTES="/usr/share/gamerx/palettes"
USER_PALETTES="$GAMERX_DIR/palettes"
THEME_JSON="$GAMERX_DIR/theme.json"

mkdir -p "$GAMERX_DIR" "$USER_CFG"

# Read a key from the TOML state file (flat keys only — that's all we use).
state_get() {
  local key="$1"
  local default="${2:-}"
  if [[ -f "$STATE" ]]; then
    python3 -c "
import sys, tomllib
try:
    d = tomllib.load(open('$STATE','rb'))
    print(d.get('$key', '$default'))
except Exception:
    print('$default')
"
  else
    printf '%s\n' "$default"
  fi
}

# Resolve palette ID to its TOML file (user dir wins).
palette_path() {
  local id="$1"
  if [[ -f "$USER_PALETTES/$id.toml" ]]; then
    printf '%s\n' "$USER_PALETTES/$id.toml"
  elif [[ -f "$SYS_PALETTES/$id.toml" ]]; then
    printf '%s\n' "$SYS_PALETTES/$id.toml"
  else
    printf '%s\n' "$SYS_PALETTES/gamerx-purple.toml"
  fi
}

# Read a [section].key from a palette TOML file.
palette_get() {
  local file="$1" section="$2" key="$3"
  python3 -c "
import sys, tomllib
d = tomllib.load(open('$file','rb'))
print(d.get('$section', {}).get('$key', ''))
"
}
