// GamerX OS · color animation
import QtQuick
import qs.services

ColorAnimation {
    duration: Theme.duration
    easing.type: Easing.BezierSpline
    easing.bezierCurve: Theme.curve
}
