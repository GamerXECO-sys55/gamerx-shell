// GamerX OS · top status bar — fully Quickshell native, replaces Waybar.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.services

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property ShellScreen modelData
        screen: modelData
        color: "transparent"

        anchors {
            top: true
            left: true
            right: true
        }
        margins {
            top:   6
            left:  10
            right: 10
        }
        implicitHeight: 38
        WlrLayershell.layer: WlrLayer.Top
        WlrLayershell.namespace: "gamerx-bar"
        exclusiveZone: 38

        StyledRect {
            anchors.fill: parent
            radius: Theme.radius + 2
            color: Qt.alpha(Theme.bg, 0.78)
            border.width: 1
            border.color: Theme.border

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 6
                anchors.rightMargin: 6
                spacing: 4

                // ===== Left =====
                BarLauncher {}
                BarWorkspaces { Layout.alignment: Qt.AlignVCenter }
                BarWindow { Layout.fillWidth: true; Layout.alignment: Qt.AlignVCenter }

                // ===== Center =====
                BarClock { Layout.alignment: Qt.AlignVCenter }

                // ===== Right =====
                Item { Layout.fillWidth: true }
                BarAria {}
                BarVolume {}
                BarNetwork {}
                BarBattery {}
                BarPower {}
            }
        }
    }
}
