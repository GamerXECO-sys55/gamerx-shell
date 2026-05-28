#!/usr/bin/env bash
# Notify Quickshell to reload the theme JSON.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

if command -v qs >/dev/null 2>&1 && pgrep -x qs >/dev/null 2>&1; then
  qs ipc call gamerx reloadTheme >/dev/null 2>&1 || true
fi
