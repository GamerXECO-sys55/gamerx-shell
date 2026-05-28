// Power button (opens PowerMenu).
import QtQuick
import qs.components
import qs.services

BarButton {
    icon: ""
    toneColor: Theme.error
    onClicked: ShellRoot.togglePowerMenu()
}
