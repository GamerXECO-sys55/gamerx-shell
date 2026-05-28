#!/usr/bin/env bash
# Activate the selected swaync style.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

style=$(state_get notification default)
SW="$XDG_CONFIG_HOME/swaync"
mkdir -p "$SW"

src="$SYS_SHELL/swaync/styles/$style"
[[ -d "$src" ]] || src="$SYS_SHELL/swaync/styles/default"

ln -sfn "$src/config.json" "$SW/config.json"
ln -sfn "$src/style.css"   "$SW/style.css"

# Hot reload swaync
if pgrep -x swaync >/dev/null 2>&1; then
  swaync-client --reload-config >/dev/null 2>&1 || true
  swaync-client --reload-css    >/dev/null 2>&1 || true
fi
