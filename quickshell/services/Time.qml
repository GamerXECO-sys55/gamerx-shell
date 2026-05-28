// GamerX OS · time service
// One ticking timer for the whole shell so we don't have N timers running.
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root
    property string clock: "--:--"
    property string date:  ""

    function update(): void {
        const d = new Date()
        clock = Qt.formatDateTime(d, "HH:mm")
        date  = Qt.formatDate(d, "ddd dd MMM")
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.update()
    }
}
