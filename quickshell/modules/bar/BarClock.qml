// Clock pill (center).
import QtQuick
import qs.components
import qs.services

StyledRect {
    implicitHeight: 26
    implicitWidth: row.implicitWidth + 20
    radius: 10
    color: Qt.alpha(Theme.accent, 0.15)

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
        StyledText {
            text: Time.clock
            color: Theme.fg
            font.bold: true
            font.pixelSize: 13
            anchors.verticalCenter: parent.verticalCenter
        }
        StyledText {
            text: " · " + Time.date
            color: Theme.fgDim
            font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
