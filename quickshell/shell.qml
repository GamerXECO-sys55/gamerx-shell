// GamerX OS · Quickshell entry point
//
// Run with:  qs -p /usr/share/gamerx-shell/quickshell
//
// Architecture (modeled after Caelestia + DankMaterialShell):
//   services/    singleton state managers (Theme, Time, Hypr, Audio, ...)
//   components/  reusable QML primitives (Anim, StyledRect, MaterialIcon, ...)
//   modules/     shipped UI (bar, launcher, powermenu, notifications, osd, controlcenter)
//
// IPC handles (callable via `qs ipc call gamerx <handle>`):
//   toggleLauncher          show/hide app launcher (also bound to SUPER+D)
//   toggleControlCenter     slide-in control center (SUPER+A)
//   togglePowerMenu         center-screen power menu (SUPER+SHIFT+P)
//   showOSD <kind> <value>  briefly flash an on-screen value
//   reloadTheme             force-reload theme.json (CLI does this automatically)

import QtQuick
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.bar
import qs.modules.launcher
import qs.modules.powermenu
import qs.modules.controlcenter
import qs.modules.osd
import qs.modules.notifications

ShellRoot {
    id: shell

    // Top status bar (per-monitor via Variants)
    Bar {}

    // Notification popups (per-monitor)
    Notifications {}

    // Singleton overlays — one instance for the whole shell
    Launcher      { id: launcher }
    ControlCenter { id: controlCenter }
    PowerMenu     { id: powerMenu }
    OSD           { id: osd }

    // Module IDs exposed to children that need to call them.
    // Modules use ShellRoot.toggleLauncher() etc. to avoid coupling.
    function toggleLauncher(): void      { launcher.visible ? launcher.close() : launcher.open() }
    function toggleControlCenter(): void { controlCenter.visible = !controlCenter.visible }
    function togglePowerMenu(): void     { powerMenu.visible = !powerMenu.visible }
    function showOSD(k: string, v: string): void { osd.show(k, v) }

    // CLI bridge
    IpcHandler {
        target: "gamerx"
        function toggleLauncher(): void         { shell.toggleLauncher() }
        function toggleControlCenter(): void    { shell.toggleControlCenter() }
        function togglePowerMenu(): void        { shell.togglePowerMenu() }
        function showOSD(kind: string, value: string): void { shell.showOSD(kind, value) }
        function reloadTheme(): void { /* Theme service watches the file directly */ }
    }
}
