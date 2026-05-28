// Brief on-screen display for volume/brightness changes.
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: panel
    visible: false
    color: "transparent"
    anchors { bottom: true }
    margins { bottom: 64 }
    implicitWidth: 320
    implicitHeight: 80
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-shell"

    property var theme: ShellRoot ? ShellRoot.root.theme : ({})
    property string kind:  ""
    property string value: ""

    function show(k, v) {
        kind = k
        value = v
        visible = true
        hideTimer.restart()
    }

    Timer {
        id: hideTimer
        interval: 1400
        onTriggered: panel.visible = false
    }

    Behavior on opacity { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
    opacity: visible ? 1 : 0

    Rectangle {
        anchors.fill: parent
        radius: panel.theme.radius || 14
        color:  panel.theme.bg || "#11162A"
        border.color: panel.theme.border || "#2A3158"
        border.width: 1

        Row {
            anchors.centerIn: parent
            spacing: 14
            Text {
                text: panel.kind === "volume" ? "" : "󰖨"
                color: panel.theme.accent || "#7C3AED"
                font.pixelSize: 22
            }
            Text {
                text: panel.value
                color: panel.theme.fg || "#E6EAF8"
                font.pixelSize: 16
                font.bold: true
            }
        }
    }
}
