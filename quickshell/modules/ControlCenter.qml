// Slide-in control center on the right.
// Quick toggles (DND, Wi-Fi, Bluetooth, performance), volume, brightness, MPRIS.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: panel
    visible: false
    anchors {
        top: true
        bottom: true
        right: true
    }
    margins {
        top:    12
        bottom: 12
        right:  12
    }
    implicitWidth: 380
    color: "transparent"
    exclusionMode: ExclusionMode.Normal
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-shell"

    property var theme: ShellRoot ? ShellRoot.root.theme : ({})

    // Animated visibility
    Behavior on opacity { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    opacity: visible ? 1 : 0

    Rectangle {
        anchors.fill: parent
        radius: panel.theme.radius || 14
        color: panel.theme.bg || "#11162A"
        border.color: panel.theme.border || "#2A3158"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            // Header
            Text {
                text: "Control Center"
                color: panel.theme.fg || "#E6EAF8"
                font.pixelSize: 18
                font.bold: true
            }

            // Toggle row
            RowLayout {
                spacing: 8
                Layout.fillWidth: true
                Repeater {
                    model: [
                        { id: "wifi",   icon: "󰖩", label: "Wi-Fi" },
                        { id: "bt",     icon: "󰂯", label: "BT" },
                        { id: "dnd",    icon: "󰂛", label: "DND" },
                        { id: "perf",   icon: "󱓧", label: "Perf" }
                    ]
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        radius: panel.theme.radius || 12
                        color: panel.theme.surface2 || "#2A3158"
                        border.color: panel.theme.border || "#2A3158"
                        border.width: 1

                        Column {
                            anchors.centerIn: parent
                            spacing: 4
                            Text {
                                text: modelData.icon
                                color: panel.theme.accent || "#7C3AED"
                                font.pixelSize: 22
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                            Text {
                                text: modelData.label
                                color: panel.theme.fgDim || "#8A93B8"
                                font.pixelSize: 11
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            // Hooks land in P3.5; for now this is a visual-only stub.
                            onClicked: console.log("toggle:", modelData.id)
                        }
                    }
                }
            }

            // Slider rows
            Repeater {
                model: ["Volume", "Brightness"]
                delegate: ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Text {
                        text: modelData
                        color: panel.theme.fgDim || "#8A93B8"
                        font.pixelSize: 11
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        height: 6
                        radius: 3
                        color: panel.theme.surface2 || "#2A3158"
                        Rectangle {
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width * 0.6
                            height: 6
                            radius: 3
                            color: panel.theme.accent || "#7C3AED"
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // Footer: power button
            Rectangle {
                Layout.fillWidth: true
                height: 44
                radius: panel.theme.radius || 12
                color: panel.theme.surface || "#1B2241"
                border.color: panel.theme.border || "#2A3158"
                border.width: 1
                Text {
                    anchors.centerIn: parent
                    text: "  Power"
                    color: panel.theme.error || "#FF5C7C"
                    font.pixelSize: 13
                    font.bold: true
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: ShellRoot.root.togglePowerMenu()
                }
            }
        }
    }
}
