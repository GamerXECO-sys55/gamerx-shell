// GamerX OS · Hyprland integration
// Exposes workspaces, active window, and dispatch helpers.
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland

Singleton {
    id: root
    readonly property var workspaces: Hyprland.workspaces.values
    readonly property int activeId: Hyprland.focusedWorkspace?.id ?? 1
    readonly property string activeTitle: Hyprland.activeToplevel?.title ?? ""

    function dispatch(cmd: string): void {
        Hyprland.dispatch(cmd)
    }
    function gotoWorkspace(id: int): void {
        Hyprland.dispatch(`workspace ${id}`)
    }
}
