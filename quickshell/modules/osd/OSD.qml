// GamerX OS · OSD (volume / brightness)
import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.services

PanelWindow {
    id: panel
    visible: false
    color: "transparent"
    anchors { bottom: true }
    margins { bottom: 64 }
    implicitWidth: 320
    implicitHeight: 64
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-osd"

    property string kind:  ""
    property string value: ""

    function show(k: string, v: string): void {
        kind = k; value = v; visible = true; hideTimer.restart()
    }

    Timer { id: hideTimer; interval: 1400; onTriggered: panel.visible = false }

    Behavior on opacity { Anim {} }
    opacity: visible ? 1 : 0

    StyledRect {
        anchors.fill: parent
        radius: Theme.radius + 2
        color: Qt.alpha(Theme.bg, 0.95)
        border.color: Theme.border
        border.width: 1

        Row {
            anchors.centerIn: parent
            spacing: 12
            MaterialIcon {
                icon: panel.kind === "volume" ? "" : ""
                color: Theme.accent
                font.pixelSize: 22
            }
            StyledText {
                text: panel.value
                color: Theme.fg
                font.bold: true
                font.pixelSize: 16
            }
        }
    }
}
