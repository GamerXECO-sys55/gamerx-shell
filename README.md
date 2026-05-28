# gamerx-shell

The Hyprland desktop shell for GamerX OS.

Hybrid architecture: **Quickshell** for overlays (launcher, control center, OSD,
notification panel, Aria overlay) and **Waybar** for the always-on status bar.
A single `gamerx-theme` CLI is the source of truth for every theme change.

## Architecture

```
shell-core/        Quickshell QML modules (launcher, control center, OSD, Aria slot)
waybar/            Waybar configs and styles
hyprland-config/   animations, keybinds, rules, gaps presets
swaync/            notification daemon styles
walker/            launcher styles (compact, list, mac, grid)
hyprlock/          lockscreen theme
swww/              wallpaper rotation logic
palettes/          6 curated palettes + matugen integration
density-presets/   compact / comfortable / spacious
animation-presets/ snappy / smooth / cinematic
gamerx-theme/      the CLI that ties it all together
```

## Why hybrid (not all-Quickshell)

All-Quickshell setups (Caelestia, Dusky-style) are visually impressive but the
status bar gets coupled to Quickshell's release cadence — when QS breaks on
update, your bar breaks too. We keep Waybar for the always-visible bar (boring
and stable) and put the wow-factor pieces in Quickshell.

## The `gamerx-theme` CLI

```bash
gamerx-theme set palette catppuccin-mocha
gamerx-theme set density compact
gamerx-theme set animation snappy
gamerx-theme set launcher mac
gamerx-theme set bar minimal
gamerx-theme set notification floating
```

The CLI:
1. Writes to a single state file (`~/.config/gamerx/state.toml`).
2. Renders templates for Hyprland, Waybar, walker, swaync, Ghostty, Quickshell,
   GTK 3/4, Qt 5/6, kvantum, cursors, and icon theme.
3. Hot-reloads everything that supports it.

The Welcome app and GamerX Settings never write configs directly — they call
this CLI.

## Status

🚧 **Phase 3 — not started.**

## See also

- [Meta repo](https://github.com/GamerXECO-sys55/gamerx-os) — spec, roadmap, decisions
- [Hyprland](https://hyprland.org)
- [Quickshell](https://quickshell.outfoxxed.me)

## License

GPL-3.0
