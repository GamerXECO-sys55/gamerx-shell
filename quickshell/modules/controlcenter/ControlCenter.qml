// GamerX OS · control center (slide-in from right)
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
    anchors { top: true; bottom: true; right: true }
    margins { top: 56; bottom: 12; right: 12 }
    implicitWidth: 380
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-controlcenter"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
    exclusiveZone: 0

    Behavior on opacity { Anim {} }
    opacity: visible ? 1 : 0

    StyledRect {
        anchors.fill: parent
        radius: Theme.radius + 2
        color: Qt.alpha(Theme.bg, 0.94)
        border.color: Theme.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 16
            spacing: 12

            StyledText {
                text: "Control Center"
                color: Theme.fg
                font.bold: true
                font.pixelSize: 18
            }

            // Quick toggles row
            GridLayout {
                Layout.fillWidth: true
                columns: 4
                rowSpacing: 8
                columnSpacing: 8

                Repeater {
                    model: [
                        { id: "wifi",  glyph: "", label: "Wi-Fi"   },
                        { id: "bt",    glyph: "", label: "BT"      },
                        { id: "dnd",   glyph: "", label: "DND"     },
                        { id: "perf",  glyph: "", label: "Perf"   }
                    ]
                    StyledRect {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 64
                        radius: Theme.radius
                        color: Qt.alpha(Theme.surface2, 0.55)
                        border.color: Theme.border
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            MaterialIcon {
                                icon: modelData.glyph
                                color: Theme.accent
                                font.pixelSize: 22
                                Layout.alignment: Qt.AlignHCenter
                            }
                            StyledText {
                                text: modelData.label
                                color: Theme.fgDim
                                font.pixelSize: 11
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                        StateLayer {
                            tone: Theme.accent
                            onClicked: console.log("toggle:", modelData.id)
                        }
                    }
                }
            }

            // Volume slider
            StyledRect {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                radius: Theme.radius
                color: Qt.alpha(Theme.surface, 0.6)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        MaterialIcon { icon: ""; color: Theme.accent; font.pixelSize: 18 }
                        StyledText { text: "Volume"; color: Theme.fgDim; Layout.fillWidth: true }
                        StyledText { text: Math.round(Audio.volume * 100) + "%"; color: Theme.fg }
                    }
                    Slider {
                        Layout.fillWidth: true
                        from: 0; to: 1
                        value: Audio.volume
                        onMoved: Audio.setVolume(value)
                    }
                }
            }

            Item { Layout.fillHeight: true }

            // Power footer
            StyledRect {
                Layout.fillWidth: true
                Layout.preferredHeight: 44
                radius: Theme.radius
                color: Qt.alpha(Theme.surface, 0.6)
                border.color: Theme.border
                border.width: 1

                Row {
                    anchors.centerIn: parent
                    spacing: 8
                    MaterialIcon { icon: ""; color: Theme.error; font.pixelSize: 16 }
                    StyledText { text: "Power"; color: Theme.error; font.bold: true }
                }
                StateLayer {
                    tone: Theme.error
                    onClicked: ShellRoot.togglePowerMenu()
                }
            }
        }
    }
}
