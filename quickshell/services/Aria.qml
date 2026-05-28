// GamerX OS · Aria bridge
// Reserved IPC slot. Vanilla edition: this stays inert (status = "inactive").
// Aria edition: Aria connects via the local API on 127.0.0.1:7173 and posts
// status updates that we read here.
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    property string status: "inactive"   // inactive | listening | thinking | speaking | error
    property string lastUtterance: ""

    // Probe the Aria local API every 8s. If anything comes back we trust it.
    Process {
        id: probe
        command: ["sh", "-c",
            "curl -fsS --max-time 1 http://127.0.0.1:7173/status 2>/dev/null || echo inactive"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                const t = (text || "").trim()
                root.status = t || "inactive"
            }
        }
    }
    Timer {
        interval: 8000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: probe.running = true
    }

    function toggleOverlay(): void {
        Quickshell.execDetached(["sh", "-c",
            "curl -fsS -X POST http://127.0.0.1:7173/overlay/toggle 2>/dev/null || true"])
    }
}
