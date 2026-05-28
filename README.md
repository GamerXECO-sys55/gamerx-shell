# gamerx-shell

The Hyprland desktop shell for GamerX OS.

Hybrid architecture: **Quickshell** for overlays (control center, OSD, power
menu, future Aria overlay) and **Waybar** for the always-on status bar. A
single `gamerx-theme` CLI is the source of truth for every theme change.

## Layout

```
hyprland/                    Modular Hyprland config
  hyprland.conf              entry point — sources every other piece
  00-monitors.conf           monitor layout
  10-input.conf              keyboard / mouse / touchpad
  20-environment.conf        Wayland env vars + cursor
  30-decoration.conf         borders, rounding, blur, shadow
  density/                   compact / comfortable / spacious
  animations/                snappy / smooth / cinematic
  50-keybinds.conf           keymap
  60-rules.conf              window + layer rules
  70-autostart.conf          exec-once entries (waybar, swaync, swww, qs, …)
  80-aria.conf               Aria reservations (SUPER+SPACE etc.)

waybar/styles/<name>/        config.jsonc + style.css
walker/styles/<name>/        config.toml + style.css
swaync/styles/<name>/        config.json + style.css
hyprlock/hyprlock.conf       template (palette tokens replaced at apply time)

quickshell/                  Quickshell shell.qml + modules/
  shell.qml                  entry point — exposes the gamerx IPC target
  qmldir
  modules/                   ControlCenter, PowerMenu, OSD, ThemeLoader, ...

renderers/                   Shell scripts called by gamerx-theme.
  10-palette.sh              merges palette + density + animation → theme.json
  20-hyprland.sh             symlinks density.conf + animations.conf
  30-waybar.sh               symlinks active style + sends SIGUSR2 to waybar
  40-walker.sh               symlinks active style
  50-swaync.sh               symlinks active style + reload
  60-hyprlock.sh             renders hyprlock.conf from template + palette
  70-quickshell.sh           IPC reload to Quickshell
  80-wallpaper.sh            swww img + symlink for hyprlock background
  _lib.sh                    shared helpers
```

## Theme propagation

```
user runs:  gamerx-theme set palette tokyo-night
            gamerx-theme set density compact
            gamerx-theme set animation snappy

CLI writes: ~/.config/gamerx/state.toml

CLI runs every renderer in /usr/share/gamerx-theme/renderers/ in name order:
  10-palette  → ~/.config/gamerx/theme.json (single source for Quickshell, hyprlock)
  20-hyprland → symlinks density.conf + animations.conf, hyprctl reload
  30-waybar   → symlinks style, pkill -SIGUSR2 waybar
  40-walker   → symlinks style
  50-swaync   → symlinks style + swaync-client --reload
  60-hyprlock → renders hyprlock.conf from template
  70-quickshell → qs ipc call gamerx reloadTheme
  80-wallpaper → swww img
```

Welcome app and GamerX Settings only call this CLI — they never write configs.

## IPC handles

```
qs ipc call gamerx toggleControlCenter
qs ipc call gamerx toggleNotifications
qs ipc call gamerx togglePowerMenu
qs ipc call gamerx showOSD volume 50
qs ipc call gamerx reloadTheme
```

## Status

🛠 **Phase 3 — in progress.** Default + minimal styles shipped per component.
More styles land as drop-ins.

## See also

- [Meta repo](https://github.com/GamerXECO-sys55/gamerx-os) — spec, roadmap, decisions
- [Hyprland](https://hyprland.org)
- [Quickshell](https://quickshell.outfoxxed.me)

## License

GPL-3.0
