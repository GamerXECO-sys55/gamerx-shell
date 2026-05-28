// Volume.
import QtQuick
import qs.components
import qs.services

BarButton {
    icon: Audio.muted ? "" : Audio.volume > 0.5 ? "" : ""
    text: Audio.muted ? "muted" : Math.round(Audio.volume * 100) + "%"
    toneColor: Audio.muted ? Theme.error : Theme.fgDim
    onClicked: Audio.toggleMuted()
}
