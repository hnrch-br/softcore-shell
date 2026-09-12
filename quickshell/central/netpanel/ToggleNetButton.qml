import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services

Rectangle {
    implicitWidth: 136
    implicitHeight: 48
    radius: 5
    color: (Network.wirelessConnected && statusMA.containsMouse)
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Network.wiredConnected
        ? Qt.alpha(Qt.tint(root.sColor, "#a67b5b"), 0.4)
        : Qt.alpha(root.sColor, 0.8)

    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.right: parent.right
        Text {
            text: Network.netIcon
            font { 
                family: "Material Symbols Outlined"
                pointSize: 14 
            }
            color: (Network.wirelessConnected && statusMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.6)
        }
        Text {
            text: Network.networkLabel
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
        id: statusMA
        anchors.fill: parent
        hoverEnabled: Network.wirelessConnected ? true : false
        cursorShape: Qt.PointingHandCursor 
        onClicked: Network.toggleNet()
    }
}
