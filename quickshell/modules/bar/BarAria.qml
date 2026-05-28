// Aria status indicator. Inert on vanilla, animated on Aria edition.
import QtQuick
import qs.components
import qs.services

BarButton {
    icon: ""    // sparkle
    toneColor: {
        switch (Aria.status) {
        case "listening": return Theme.accentAlt
        case "thinking":  return Theme.highlight
        case "speaking":  return Theme.success
        case "error":     return Theme.error
        default:          return Theme.fgDim
        }
    }
    onClicked: Aria.toggleOverlay()
}
