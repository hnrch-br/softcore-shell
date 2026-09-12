import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: dndMA.containsMouse 
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b") 
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: dndMA.containsMouse 
        ? "transparent" 
        : Qt.alpha(root.sColor, 0.4)
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 15
        Text {
            id: dndIcon
            text: "do_not_disturb_on"
            font {
                family: "Material Symbols Outlined"
                pointSize: 16.7 
            }
            color: dndMA.containsMouse
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
        }

        Text {
            id: dndStatus
            text: "dndStatus"
            font {
                family: "Pixelify Sans"
                pixelSize: 14
            }
            color: dndMA.containsMouse
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    MouseArea {
        id: dndMA
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
    }
}
