// Network status.
import QtQuick
import qs.components
import qs.services

BarButton {
    icon: {
        switch (Network.state) {
        case "wifi":     return ""
        case "ethernet": return ""
        case "online":   return ""
        case "offline":  return ""
        default:         return ""
        }
    }
    toneColor: Network.state === "offline" ? Theme.error : Theme.fgDim
    onClicked: Quickshell.execDetached(["nm-connection-editor"])
}
