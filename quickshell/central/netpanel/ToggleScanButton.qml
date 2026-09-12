import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services

Rectangle {
    implicitWidth: 136
    implicitHeight: 48
    radius: 5
    color: (Network.wirelessConnected && containsMouse)
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Network.scanning
        ? Qt.tint(Qt.alpha(root.sColor, 0.6), "#a67b5b")
        : Qt.alpha(root.mColor, 0.8)

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        Text {
            text: "explore"
            font { 
                family: "Material Symbols Outlined"
                pointSize: 14 
            }
            color: (Network.wirelessConnected && statusMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.6)
        }
        Text {
            text: Network.scanStatus
            font {
                family: "Pixelify Sans"
                pixelSize: 15
            }
            color: (Network.wirelessConnected && statusMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.6)
        }
    }

    MouseArea {
        id: scanningMA
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Network.wirelessConnected ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        onClicked: Network.toggleScan()
    }
}
