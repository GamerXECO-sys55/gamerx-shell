// GamerX OS · app discovery via DesktopEntries
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell

Singleton {
    id: root

    function search(query: string): var {
        const q = (query || "").toLowerCase().trim()
        const all = DesktopEntries.applications.values || []
        if (!q) return all.slice(0, 100)
        const matches = []
        for (let i = 0; i < all.length; i++) {
            const e = all[i]
            const name = (e.name || "").toLowerCase()
            const gen  = (e.genericName || "").toLowerCase()
            if (name.includes(q) || gen.includes(q)) matches.push(e)
        }
        return matches
    }

    function launch(entry): void {
        if (entry && entry.execute) entry.execute()
    }
}
