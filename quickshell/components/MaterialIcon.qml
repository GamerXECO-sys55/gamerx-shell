// GamerX OS · Material Symbols icon component
// Falls back to JetBrainsMono Nerd Font if Material Symbols isn't installed.
import QtQuick
import qs.services

Text {
    id: root
    property string icon: ""
    property int fill: 0
    property int weight: 400

    text: root.icon
    color: Theme.fg
    renderType: Text.NativeRendering
    font.family: "Material Symbols Rounded"
    font.pixelSize: 18
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter

    Behavior on color { CAnim {} }
}
