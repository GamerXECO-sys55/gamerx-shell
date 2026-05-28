// GamerX OS · standard pill button used in the bar / control center
import QtQuick
import qs.services

StyledRect {
    id: root
    property string text: ""
    property string icon: ""
    property color toneColor: Theme.fg
    signal clicked

    implicitHeight: 28
    implicitWidth: row.implicitWidth + 24
    radius: 14
    color: hovered ? Theme.surface2 : "transparent"
    property bool hovered: stateLayer.containsMouse

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
        MaterialIcon {
            visible: root.icon.length > 0
            icon: root.icon
            color: root.toneColor
            font.pixelSize: 16
            anchors.verticalCenter: parent.verticalCenter
        }
        StyledText {
            visible: root.text.length > 0
            text: root.text
            color: root.toneColor
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    StateLayer {
        id: stateLayer
        tone: root.toneColor
        onClicked: root.clicked()
    }
}
