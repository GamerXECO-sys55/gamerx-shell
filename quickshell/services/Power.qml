// GamerX OS · battery & power state via UPower
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    id: root
    readonly property bool present: UPower.displayDevice?.isLaptopBattery ?? false
    readonly property real percent: (UPower.displayDevice?.percentage ?? 0) * 100
    readonly property bool charging: (UPower.displayDevice?.state ?? UPowerDeviceState.Unknown) === UPowerDeviceState.Charging
    readonly property string status:
        !present     ? "ac" :
        charging     ? "charging" :
        percent < 15 ? "critical" :
        percent < 30 ? "warning" :
                       "ok"
}
