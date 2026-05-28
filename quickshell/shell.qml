// GamerX OS · Quickshell entry point
// Loads the live theme JSON, exposes IPC, and instantiates the overlays.
//
// Run with:
//   qs -p /usr/share/gamerx-shell
//
// IPC handles (callable via `qs ipc call gamerx <handle>`):
//   toggleControlCenter
//   toggleNotifications
//   togglePowerMenu
//   showOSD <kind> <value>     — kind: volume | brightness
//
// Aria edition adds an `aria` IPC target via a separate QML module.

import QtQuick
import Quickshell
import Quickshell.Io
import "modules"

ShellRoot {
    id: root

    // Live theme — populated by themeLoader; modules bind to root.theme.
    property var theme: ({
        bg:        "#11162A",
        bgAlt:     "#1B2241",
        surface:   "#1B2241",
        surface2:  "#2A3158",
        fg:        "#E6EAF8",
        fgDim:     "#8A93B8",
        border:    "#2A3158",
        accent:    "#7C3AED",
        accentAlt: "#00D9FF",
        highlight: "#FF2EC4",
        warn:      "#FFB347",
        error:     "#FF5C7C",
        success:   "#5BE3A1",
        radius:    12,
        gap:       8,
        animMs:    220
    })

    ThemeLoader { id: themeLoader; onThemeLoaded: root.theme = data }

    // ---- Overlays ---------------------------------------------------------
    ControlCenter   { id: controlCenter }
    PowerMenu       { id: powerMenu }
    OSD             { id: osd }

    // ---- IPC --------------------------------------------------------------
    IpcHandler {
        target: "gamerx"

        function toggleControlCenter(): void {
            controlCenter.visible = !controlCenter.visible
        }
        function toggleNotifications(): void {
            // We delegate the notification panel to swaync to avoid duplication.
            // This shortcut just toggles its visibility via D-Bus.
            Quickshell.execDetached(["swaync-client", "-t", "-sw"])
        }
        function togglePowerMenu(): void {
            powerMenu.visible = !powerMenu.visible
        }
        function showOSD(kind: string, value: string): void {
            osd.show(kind, value)
        }
        function reloadTheme(): void {
            themeLoader.reload()
        }
    }
}
