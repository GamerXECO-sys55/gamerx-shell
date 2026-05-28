// GamerX OS · Material state layer (hover/press ripple)
// Drop into any clickable surface as the topmost child.
import QtQuick
import qs.services

MouseArea {
    id: root
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    property color tone: Theme.fg

    Rectangle {
        anchors.fill: parent
        radius: parent.parent.radius || 0
        color: root.tone
        opacity: root.pressed ? 0.18 : root.containsMouse ? 0.10 : 0
        Behavior on opacity { Anim {} }
    }
}
