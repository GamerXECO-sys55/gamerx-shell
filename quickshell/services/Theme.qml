// GamerX OS · Theme service
// Single source of truth for colors, spacing, durations, curves.
// Watches ~/.config/gamerx/theme.json (written by the gamerx-theme CLI's
// 10-palette renderer) and exposes typed properties to all QML modules.
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // Colors — bound to theme.json. Defaults are GamerX Purple.
    property color bg:        "#11162A"
    property color bgAlt:     "#1B2241"
    property color surface:   "#1B2241"
    property color surface2:  "#2A3158"
    property color fg:        "#E6EAF8"
    property color fgDim:     "#8A93B8"
    property color border:    "#2A3158"
    property color accent:    "#7C3AED"
    property color accentAlt: "#00D9FF"
    property color highlight: "#FF2EC4"
    property color warn:      "#FFB347"
    property color error:     "#FF5C7C"
    property color success:   "#5BE3A1"

    // Geometry & motion (driven by density + animation state keys)
    property int radius: 12
    property int gap:    8
    property int duration: 220
    property var curve:  [0.16, 1.0, 0.30, 1.0]   // GamerX cubic-bezier

    // String labels (bind to UI as needed)
    property string palette:   "gamerx-purple"
    property string density:   "comfortable"
    property string animation: "smooth"

    readonly property string themeFile: Quickshell.env("HOME") + "/.config/gamerx/theme.json"

    function applyJson(text: string): void {
        try {
            const d = JSON.parse(text)
            if (d.bg)        bg        = d.bg
            if (d.bgAlt)     bgAlt     = d.bgAlt
            if (d.surface)   surface   = d.surface
            if (d.surface2)  surface2  = d.surface2
            if (d.fg)        fg        = d.fg
            if (d.fgDim)     fgDim     = d.fgDim
            if (d.border)    border    = d.border
            if (d.accent)    accent    = d.accent
            if (d.accentAlt) accentAlt = d.accentAlt
            if (d.highlight) highlight = d.highlight
            if (d.warn)      warn      = d.warn
            if (d.error)     error     = d.error
            if (d.success)   success   = d.success
            if (d.radius !== undefined) radius   = d.radius
            if (d.gap    !== undefined) gap      = d.gap
            if (d.animMs !== undefined) duration = d.animMs
            if (d.palette)   palette   = d.palette
            if (d.density)   density   = d.density
            if (d.animation) animation = d.animation
        } catch (e) {
            console.warn("Theme.applyJson:", e)
        }
    }

    FileView {
        path: root.themeFile
        watchChanges: true
        onLoaded: root.applyJson(text())
    }

    Component.onCompleted: console.log("Theme service ready")
}
