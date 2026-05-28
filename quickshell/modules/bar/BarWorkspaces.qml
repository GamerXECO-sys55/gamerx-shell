// Workspace pill row.
import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services

RowLayout {
    spacing: 2

    Repeater {
        model: 10  // 1..10
        Item {
            id: ws
            required property int index
            readonly property int wsId: ws.index + 1
            readonly property bool active: Hypr.activeId === wsId
            readonly property bool occupied: {
                const list = Hypr.workspaces || []
                for (let i = 0; i < list.length; i++)
                    if (list[i].id === wsId) return true
                return false
            }

            Layout.preferredWidth: active ? 24 : 14
            Layout.preferredHeight: 14
            Behavior on Layout.preferredWidth { Anim {} }

            StyledRect {
                anchors.centerIn: parent
                width: parent.width
                height: 6
                radius: height / 2
                color: ws.active    ? Theme.accent
                     : ws.occupied  ? Qt.alpha(Theme.fg, 0.65)
                                    : Qt.alpha(Theme.fgDim, 0.35)
            }

            StateLayer {
                tone: Theme.accent
                onClicked: Hypr.gotoWorkspace(ws.wsId)
            }
        }
    }
}
