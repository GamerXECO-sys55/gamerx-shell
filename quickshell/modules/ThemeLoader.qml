// Watches ~/.config/gamerx/theme.json and emits themeLoaded(data).
import QtQuick
import Quickshell
import Quickshell.Io

QtObject {
    id: loader
    signal themeLoaded(var data)

    readonly property string themeFile: Quickshell.env("HOME") + "/.config/gamerx/theme.json"

    function reload() {
        themeFileWatcher.path = ""        // trigger a re-read
        themeFileWatcher.path = themeFile
    }

    FileView {
        id: themeFileWatcher
        path: loader.themeFile
        watchChanges: true
        onLoaded: {
            try {
                const obj = JSON.parse(text())
                loader.themeLoaded(obj)
            } catch (e) {
                console.warn("ThemeLoader: bad theme.json:", e)
            }
        }
    }

    Component.onCompleted: themeFileWatcher.reload()
}
