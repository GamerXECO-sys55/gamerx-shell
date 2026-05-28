#!/usr/bin/env bash
# Render the merged theme.json (palette + density + animation + radii)
# that everything else (Quickshell, GTK, Qt, terminal) reads.
set -euo pipefail
. "$(dirname "$0")/_lib.sh"

palette_id=$(state_get palette gamerx-purple)
density=$(state_get density comfortable)
animation=$(state_get animation smooth)

if [[ "$palette_id" == "auto" ]]; then
  palette_id="_auto"   # matugen-generated palette
fi

PALETTE_FILE=$(palette_path "$palette_id")

bg=$(palette_get  "$PALETTE_FILE" base bg)
bg_alt=$(palette_get "$PALETTE_FILE" base bg_alt)
surface=$(palette_get "$PALETTE_FILE" base surface)
surface2=$(palette_get "$PALETTE_FILE" base surface_2)
fg=$(palette_get "$PALETTE_FILE" base fg)
fg_dim=$(palette_get "$PALETTE_FILE" base fg_dim)
border=$(palette_get "$PALETTE_FILE" base border)
accent=$(palette_get "$PALETTE_FILE" accent primary)
accent_alt=$(palette_get "$PALETTE_FILE" accent secondary)
highlight=$(palette_get "$PALETTE_FILE" accent tertiary)
warn=$(palette_get "$PALETTE_FILE" state warn)
error=$(palette_get "$PALETTE_FILE" state error)
success=$(palette_get "$PALETTE_FILE" state success)

# Density → radius
case "$density" in
  compact)      radius=8;  gap=4  ;;
  comfortable)  radius=12; gap=8  ;;
  spacious)     radius=16; gap=14 ;;
  *)            radius=12; gap=8  ;;
esac

# Animation → ms
case "$animation" in
  snappy)     animMs=120 ;;
  smooth)     animMs=220 ;;
  cinematic)  animMs=380 ;;
  *)          animMs=220 ;;
esac

cat > "$THEME_JSON" <<EOF
{
  "palette": "$palette_id",
  "density": "$density",
  "animation": "$animation",
  "bg":        "$bg",
  "bgAlt":     "$bg_alt",
  "surface":   "$surface",
  "surface2":  "$surface2",
  "fg":        "$fg",
  "fgDim":     "$fg_dim",
  "border":    "$border",
  "accent":    "$accent",
  "accentAlt": "$accent_alt",
  "highlight": "$highlight",
  "warn":      "$warn",
  "error":     "$error",
  "success":   "$success",
  "radius":    $radius,
  "gap":       $gap,
  "animMs":    $animMs
}
EOF
