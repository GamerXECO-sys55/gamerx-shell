// Active window title (center-left).
import QtQuick
import qs.components
import qs.services

StyledText {
    text: Hypr.activeTitle
    color: Theme.fgDim
    font.pixelSize: 12
    elide: Text.ElideRight
    leftPadding: 12
}
