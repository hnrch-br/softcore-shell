import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Io

import qs.services

Rectangle {
    id: netRect
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: (Network.wirelessConnected && netMA.containsMouse)
        ? Qt.tint(Qt.alpha(root.sColor, 0.6), "#cced752b")
        : Network.wirelessConnected
        ? Qt.tint(Qt.alpha(root.mColor, 0.6), "#af895f")
        : Network.wiredConnected
        ? Qt.tint(Qt.alpha(root.mColor, 0.4), "#cca67b5b")
        : Qt.alpha(root.mColor, 0.6)
        border.width: 1
    border.color: (Network.wirelessConnected && netMA.containsMouse)
        ? Qt.tint(Qt.alpha(root.sColor, 0.2), "#cca67b5b")
        : Network.wirelessConnected
        ? "transparent"
        : Network.wiredConnected
        ? "transparent"
        : root.sColor
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 15
        Text {
            id: netIcon
            text: Network.netIcon
            font { 
                family: "Material Symbols Outlined"
                pointSize: 16.7
            }
            color: (Network.wirelessConnected && netMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.6)
        }

        Text {
            id: netName
            text: Network.networkLabel
            font { 
                family: "Pixelify Sans"
                pixelSize: 14
            }
            color: (Network.wirelessConnected && netMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.6)
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    MouseArea {
        id: netMA
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Network.toggleNet()
        onPressAndHold: wifiListProc.running = true
    }

    Process {
        id: wifiListProc
        command: ["qs", "ipc", "call", "netList", "toggleVisible"]
    }
}
