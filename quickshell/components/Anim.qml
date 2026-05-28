// GamerX OS · animation primitives
// One source of truth for durations and curves. Modules use:
//   Behavior on x { Anim {} }
//   Behavior on color { CAnim {} }
import QtQuick
import qs.services

NumberAnimation {
    duration: Theme.duration
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Theme.curve
}
