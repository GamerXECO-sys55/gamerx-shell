// GamerX OS · native notifications (replaces swaync's notification popups)
// Notifications appear top-right, stacked, auto-dismiss after timeout.
// Critical notifications stay until dismissed.
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import qs.components
import qs.services

Variants {
    model: Quickshell.screens

    PanelWindow {
        required property ShellScreen modelData
        screen: modelData
        color: "transparent"
        anchors { top: true; right: true }
        margins { top: 56; right: 14 }
        implicitWidth: 380
        implicitHeight: stack.implicitHeight + 12
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.namespace: "gamerx-notifications"
        exclusiveZone: 0
        // Hide entirely when nothing to show
        visible: stack.children.length > 0

        NotificationServer {
            id: notifServer
            keepOnReload: false
            actionsSupported: true
            bodyImagesSupported: true
            bodyMarkupSupported: true
            bodySupported: true
            imageSupported: true
            persistenceSupported: true

            onNotification: notif => {
                notif.tracked = true
                stack.add(notif)
            }
        }

        ColumnLayout {
            id: stack
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 6
            spacing: 8

            function add(notif): void {
                const c = popupComponent.createObject(stack, { notif: notif })
                if (notif.urgency !== NotificationUrgency.Critical) {
                    Qt.callLater(() => Qt.createQmlObject(
                        `import QtQuick; Timer { interval: 6000; running: true; onTriggered: { parent.dismiss() } }`,
                        c, "autodismiss"))
                }
            }
        }

        Component {
            id: popupComponent
            StyledRect {
                id: popup
                property var notif

                Layout.preferredWidth: 360
                implicitHeight: content.implicitHeight + 20
                radius: Theme.radius
                color: Qt.alpha(Theme.bg, 0.94)
                border.width: 1
                border.color: notif?.urgency === NotificationUrgency.Critical ? Theme.error : Theme.border

                function dismiss(): void {
                    if (notif) notif.dismiss()
                    popup.destroy()
                }

                Behavior on opacity { Anim {} }

                ColumnLayout {
                    id: content
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        // App icon (uses appName as fallback identifier)
                        Image {
                            source: notif?.appIcon ? "image://icon/" + notif.appIcon : ""
                            sourceSize.width: 28
                            sourceSize.height: 28
                            Layout.preferredWidth: 28
                            Layout.preferredHeight: 28
                            visible: status === Image.Ready
                            asynchronous: true
                        }
                        StyledText {
                            text: notif?.summary || ""
                            color: Theme.fg
                            font.weight: Font.Bold
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }
                        MaterialIcon {
                            icon: ""
                            color: Theme.fgDim
                            font.pixelSize: 14
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: popup.dismiss()
                            }
                        }
                    }
                    StyledText {
                        visible: text.length > 0
                        text: notif?.body || ""
                        color: Theme.fgDim
                        font.pixelSize: 12
                        wrapMode: Text.Wrap
                        Layout.fillWidth: true
                    }
                }
            }
        }
    }
}
