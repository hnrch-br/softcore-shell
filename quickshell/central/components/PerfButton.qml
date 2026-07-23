import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
Rectangle {
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: perMA.containsMouse
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: perMA.containsMouse 
        ? "transparent" 
        : Qt.alpha(root.sColor, 0.4)
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 15
        Text {
            id: perIcon
            text: "bolt_boost"
            font {
                family: "Material Symbols Outlined"
                pointSize: 16.7
            }
            color: perMA.containsMouse 
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
        }

        Text {
            id: perType 
            text: "perType"
            font { 
                family: "Pixelify Sans"
                pixelSize: 14
            }
            color: perMA.containsMouse 
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    MouseArea {
        id: perMA
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }
}
