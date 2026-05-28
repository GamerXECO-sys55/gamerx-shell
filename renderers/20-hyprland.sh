#!/usr/bin/env bash
# Symlink the active density and animation preset into the user's Hyprland config.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

HYPR_CFG="$XDG_CONFIG_HOME/hypr"
SYS_HYPR="$SYS_SHELL/hyprland"
mkdir -p "$HYPR_CFG/local"

# First-time bootstrap: copy non-managed configs if absent.
for f in 00-monitors.conf 10-input.conf 20-environment.conf 30-decoration.conf \
         50-keybinds.conf 60-rules.conf 70-autostart.conf 80-aria.conf hyprland.conf; do
  [[ -e "$HYPR_CFG/$f" ]] || cp "$SYS_HYPR/$f" "$HYPR_CFG/$f"
done

density=$(state_get density comfortable)
animation=$(state_get animation smooth)

ln -sfn "$SYS_HYPR/density/${density}.conf"     "$HYPR_CFG/density.conf"
ln -sfn "$SYS_HYPR/animations/${animation}.conf" "$HYPR_CFG/animations.conf"

# Hot reload if Hyprland is running
if command -v hyprctl >/dev/null 2>&1 && [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
  hyprctl reload >/dev/null 2>&1 || true
fi
