#!/usr/bin/env bash
# Activate the selected rofi-wayland style.
set -euo pipefail
. "$(dirname "$(readlink -f "$0")")/_lib.sh"

style=$(state_get launcher list)
RC="$XDG_CONFIG_HOME/rofi"
mkdir -p "$RC/themes"

src="$SYS_SHELL/rofi/styles/$style"
[[ -d "$src" ]] || src="$SYS_SHELL/rofi/styles/list"

# Symlink the active style as the default theme rofi loads.
ln -sfn "$src/config.rasi" "$RC/config.rasi"
# Provide a "list" / "grid" alias inside themes/ so users can override per-launch.
for s in "$SYS_SHELL/rofi/styles/"*/; do
  name=$(basename "$s")
  ln -sfn "$s/config.rasi" "$RC/themes/${name}.rasi"
done

# rofi has no daemon to reload — config is read on each invocation.
