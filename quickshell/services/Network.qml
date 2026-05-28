// GamerX OS · network status (NetworkManager via nmcli)
// We don't ship a full NM library binding — a polled nmcli call is enough
// for a status icon and tooltip. Heavier UIs go through nm-connection-editor.
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string state: "loading"      // online | offline | wifi | ethernet | loading
    property string ssid:  ""
    property int    signal: 0

    Process {
        id: query
        command: ["sh", "-c",
            "nmcli -t -f STATE,CONNECTION,DEVICE,TYPE device 2>/dev/null | head -20 || echo unknown"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const t = text || ""
                if (t.includes("connected")) {
                    if (t.includes("wifi")) root.state = "wifi"
                    else if (t.includes("ethernet")) root.state = "ethernet"
                    else root.state = "online"
                } else {
                    root.state = "offline"
                }
            }
        }
    }
    Timer {
        interval: 4000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: query.running = true
    }
}
