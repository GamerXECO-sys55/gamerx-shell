// Launcher button (left edge).
import QtQuick
import qs.components
import qs.services

Item {
    implicitWidth: 36
    implicitHeight: 36

    StyledRect {
        anchors.fill: parent
        anchors.margins: 4
        radius: 10
        color: hovered ? Qt.alpha(Theme.accent, 0.20) : "transparent"
        property bool hovered: stateLayer.containsMouse

        MaterialIcon {
            anchors.centerIn: parent
            icon: ""
            color: Theme.accent
            font.pixelSize: 18
        }

        StateLayer {
            id: stateLayer
            tone: Theme.accent
            onClicked: ShellRoot.toggleLauncher()
        }
    }
}
