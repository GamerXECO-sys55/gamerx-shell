#!/usr/bin/env bash
# Activate the selected walker style.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

launcher=$(state_get launcher list)
WK="$XDG_CONFIG_HOME/walker"
mkdir -p "$WK"

src="$SYS_SHELL/walker/styles/$launcher"
[[ -d "$src" ]] || src="$SYS_SHELL/walker/styles/list"

ln -sfn "$src/config.toml" "$WK/config.toml"
ln -sfn "$src/style.css"   "$WK/style.css"

# walker re-reads config on next invocation; nothing to hot-reload.
