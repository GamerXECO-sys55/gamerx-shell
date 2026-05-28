// GamerX OS · native Quickshell launcher
// Replaces rofi for app launching. Spotlight-style: top-center, type-to-search.
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.services

PanelWindow {
    id: root
    visible: false
    color: "transparent"
    anchors { top: true; left: true; right: true; bottom: true }
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "gamerx-launcher"
    WlrLayershell.keyboardFocus: visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    exclusiveZone: 0

    Behavior on opacity { Anim {} }
    opacity: visible ? 1 : 0

    function open(): void { searchField.text = ""; visible = true; searchField.forceActiveFocus() }
    function close(): void { visible = false }

    // ---- Backdrop -------------------------------------------------------
    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.45
        MouseArea { anchors.fill: parent; onClicked: root.close() }
    }

    // ---- Card -----------------------------------------------------------
    StyledRect {
        id: card
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 90
        width: 720
        height: 520
        radius: Theme.radius + 4
        color: Qt.alpha(Theme.bg, 0.92)
        border.color: Theme.border
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // Search bar
            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 56
                Layout.margins: 0
                spacing: 12

                MaterialIcon {
                    Layout.leftMargin: 22
                    icon: ""
                    color: Theme.accent
                    font.pixelSize: 22
                }
                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    Layout.rightMargin: 22
                    placeholderText: "Search apps, files, or type a query..."
                    color: Theme.fg
                    placeholderTextColor: Theme.fgDim
                    font.pixelSize: 16
                    background: Item {}
                    Keys.onEscapePressed: root.close()
                    Keys.onDownPressed: { resultsList.incrementCurrentIndex(); event.accepted = true }
                    Keys.onUpPressed:   { resultsList.decrementCurrentIndex(); event.accepted = true }
                    Keys.onReturnPressed: resultsList.activate()
                    onTextChanged: resultsList.refresh()
                    Component.onCompleted: refreshTimer.start()
                }
            }

            // Divider
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: Theme.border
            }

            // Results
            ListView {
                id: resultsList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                spacing: 2
                topMargin: 8; bottomMargin: 8
                leftMargin: 8; rightMargin: 8

                model: ListModel { id: resultsModel }

                function refresh(): void {
                    resultsModel.clear()
                    const matches = Apps.search(searchField.text)
                    for (let i = 0; i < Math.min(matches.length, 100); i++) {
                        const e = matches[i]
                        resultsModel.append({
                            name:    e.name || "Unknown",
                            comment: e.comment || e.genericName || "",
                            iconN:   e.icon || "application-x-executable",
                            entryRef: i
                        })
                    }
                    resultsList.currentIndex = matches.length > 0 ? 0 : -1
                }
                function activate(): void {
                    if (currentIndex < 0) return
                    const matches = Apps.search(searchField.text)
                    if (matches[currentIndex]) {
                        Apps.launch(matches[currentIndex])
                        root.close()
                    }
                }

                delegate: StyledRect {
                    width: ListView.view.width
                    height: 52
                    radius: 10
                    color: ListView.isCurrentItem ? Qt.alpha(Theme.accent, 0.22) : "transparent"
                    border.width: ListView.isCurrentItem ? 1 : 0
                    border.color: Theme.highlight

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14
                        anchors.rightMargin: 14
                        spacing: 12

                        Image {
                            source: model.iconN ? "image://icon/" + model.iconN : ""
                            sourceSize.width: 32
                            sourceSize.height: 32
                            Layout.preferredWidth: 32
                            Layout.preferredHeight: 32
                            asynchronous: true
                            fillMode: Image.PreserveAspectFit
                        }
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            StyledText {
                                text: model.name
                                color: Theme.fg
                                font.weight: Font.Medium
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                            StyledText {
                                visible: model.comment.length > 0
                                text: model.comment
                                color: Theme.fgDim
                                font.pixelSize: 11
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { resultsList.currentIndex = index; resultsList.activate() }
                    }
                }
            }

            Timer {
                id: refreshTimer
                interval: 1
                onTriggered: resultsList.refresh()
            }
        }
    }
}
