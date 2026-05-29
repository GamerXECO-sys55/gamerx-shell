// GamerX OS · Quickshell minimal shell (v0)
//
// A safe baseline that's GUARANTEED to load on Quickshell 0.3.
// Larger modules (launcher, powermenu, controlcenter, etc.) will be wired in
// once individually validated. For now: a clean themed bar so users see
// something better than a fallback Waybar.
//
// Run with:  qs -p /usr/share/gamerx-shell/quickshell

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

ShellRoot {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property ShellScreen modelData
            screen: modelData
            color: "transparent"

            anchors { top: true; left: true; right: true }
            margins { top: 6; left: 10; right: 10 }
            implicitHeight: 36
            exclusiveZone: 36

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "gamerx-bar"

            // Background pill
            Rectangle {
                anchors.fill: parent
                radius: 14
                color: "#dd0A0E1A"
                border.color: "#332A3158"
                border.width: 1
            }

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin:  14
                anchors.rightMargin: 14
                spacing: 12

                // ---- Left: app icon + workspaces -------------------------
                Text {
                    text: "GamerX"
                    color: "#E6EAF8"
                    font.pixelSize: 13
                    font.bold: true
                    font.family: "Inter, sans-serif"
                }

                RowLayout {
                    spacing: 6
                    Repeater {
                        model: Hyprland.workspaces.values
                        delegate: Rectangle {
                            required property var modelData
                            implicitWidth: 22
                            implicitHeight: 22
                            radius: 8
                            color: modelData.focused ? "#7C3AED"
                                                     : (modelData.active ? "#552A3158" : "#222A3158")
                            border.color: modelData.focused ? "#9966FF" : "transparent"
                            border.width: 1
                            Behavior on color { ColorAnimation { duration: 180 } }

                            Text {
                                anchors.centerIn: parent
                                text: parent.modelData.id
                                color: parent.modelData.focused ? "#FFFFFF" : "#8A93B8"
                                font.pixelSize: 11
                                font.bold: true
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: Hyprland.dispatch("workspace " + parent.modelData.id)
                            }
                        }
                    }
                }

                // ---- Center spacer ---------------------------------------
                Item { Layout.fillWidth: true }

                // ---- Active window title --------------------------------
                Text {
                    Layout.maximumWidth: 360
                    text: Hyprland.activeToplevel?.title ?? ""
                    color: "#E6EAF8"
                    font.pixelSize: 12
                    font.family: "Inter, sans-serif"
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                }

                Item { Layout.fillWidth: true }

                // ---- Right: clock ---------------------------------------
                Text {
                    id: clockLabel
                    color: "#E6EAF8"
                    font.pixelSize: 13
                    font.bold: true
                    font.family: "JetBrainsMono Nerd Font, monospace"
                    text: Qt.formatDateTime(new Date(), "ddd  hh:mm")
                }
                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: clockLabel.text = Qt.formatDateTime(new Date(), "ddd  hh:mm")
                }
            }
        }
    }
}
