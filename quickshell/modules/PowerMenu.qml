// Center-screen power menu: lock / suspend / restart / shutdown.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: panel
    visible: false
    color: "transparent"
    anchors { top: true; bottom: true; left: true; right: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-shell"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

    property var theme: ShellRoot ? ShellRoot.root.theme : ({})

    Behavior on opacity { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }
    opacity: visible ? 1 : 0

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.55
        MouseArea { anchors.fill: parent; onClicked: panel.visible = false }
    }

    Rectangle {
        anchors.centerIn: parent
        width:  520
        height: 220
        radius: panel.theme.radius || 16
        color:  panel.theme.bg || "#11162A"
        border.color: panel.theme.border || "#2A3158"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            Text {
                text: "Power"
                color: panel.theme.fg || "#E6EAF8"
                font.pixelSize: 18; font.bold: true
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                Repeater {
                    model: [
                        { icon: "",  label: "Lock",     cmd: "hyprlock" },
                        { icon: "󰒲", label: "Suspend",  cmd: "systemctl suspend" },
                        { icon: "",  label: "Restart",  cmd: "systemctl reboot"  },
                        { icon: "",  label: "Shutdown", cmd: "systemctl poweroff" }
                    ]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        radius: panel.theme.radius || 12
                        color:  panel.theme.surface2 || "#2A3158"
                        border.color: panel.theme.border || "#2A3158"
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 6
                            Text {
                                text: modelData.icon
                                color: panel.theme.accent || "#7C3AED"
                                font.pixelSize: 28
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: modelData.label
                                color: panel.theme.fg || "#E6EAF8"
                                font.pixelSize: 12
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                Quickshell.execDetached(["sh", "-c", modelData.cmd])
                                panel.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    // Esc to dismiss
    Keys.onEscapePressed: panel.visible = false
}
