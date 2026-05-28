// GamerX OS · animated rectangle base
import QtQuick

Rectangle {
    color: "transparent"
    Behavior on color { CAnim {} }
    Behavior on radius { Anim {} }
}
