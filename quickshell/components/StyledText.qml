// GamerX OS · default text component
import QtQuick
import qs.services

Text {
    renderType: Text.NativeRendering
    color: Theme.fg
    font.family: "Inter"
    font.pixelSize: 13

    Behavior on color { CAnim {} }
}
