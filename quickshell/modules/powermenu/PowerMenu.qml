// GamerX OS · centered power menu (lock / suspend / restart / shutdown)
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.services

PanelWindow {
    id: panel
    visible: false
    color: "transparent"
    anchors { top: true; bottom: true; left: true; right: true }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-powermenu"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    Behavior on opacity { Anim {} }
    opacity: visible ? 1 : 0

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.55
        MouseArea { anchors.fill: parent; onClicked: panel.visible = false }
    }

    StyledRect {
        anchors.centerIn: parent
        width:  560
        height: 220
        radius: Theme.radius + 4
        color: Qt.alpha(Theme.bg, 0.96)
        border.color: Theme.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            StyledText {
                text: "Power"
                color: Theme.fg
                font.bold: true
                font.pixelSize: 18
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 12
                Repeater {
                    model: [
                        { glyph: "",  label: "Lock",     cmd: "hyprlock" },
                        { glyph: "",  label: "Suspend",  cmd: "systemctl suspend" },
                        { glyph: "",  label: "Restart",  cmd: "systemctl reboot" },
                        { glyph: "",  label: "Shutdown", cmd: "systemctl poweroff" }
                    ]
                    StyledRect {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 110
                        radius: Theme.radius
                        color: Qt.alpha(Theme.surface2, 0.6)
                        border.color: Theme.border
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 4
                            MaterialIcon {
                                icon: modelData.glyph
                                color: Theme.accent
                                font.pixelSize: 28
                                Layout.alignment: Qt.AlignHCenter
                            }
                            StyledText {
                                text: modelData.label
                                color: Theme.fg
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        StateLayer {
                            tone: Theme.accent
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

    Keys.onEscapePressed: panel.visible = false
}
