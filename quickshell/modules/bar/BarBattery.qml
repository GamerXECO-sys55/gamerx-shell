// Battery (hidden on desktops).
import QtQuick
import qs.components
import qs.services

BarButton {
    visible: Power.present
    icon: Power.charging ? "" : ""
    text: Math.round(Power.percent) + "%"
    toneColor: Power.status === "critical" ? Theme.error
             : Power.status === "warning"  ? Theme.warn
             : Power.status === "charging" ? Theme.success
                                            : Theme.fgDim
}
