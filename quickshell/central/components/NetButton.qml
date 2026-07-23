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
    color: (Network.wiredConnected || Network.wirelessConnected)
        ? Qt.tint(Qt.alpha(root.sColor, 0.6), "#a67b5b")
        : netMA.containsMouse
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b") 
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: netMA.containsMouse 
        ? "transparent" 
        : Qt.alpha(root.sColor, 0.4)
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
            color: netMA.containsMouse 
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
        }

        Text {
            id: netName
            text: Network.networkLabel
            font { 
                family: "Pixelify Sans"
                pixelSize: 14
            }
            color: netMA.containsMouse 
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    MouseArea {
        id: netMA
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Network.wirelessConnected ? Qt.PointingHandCursor : Qt.ForbiddenCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if ((mouse.button) == Qt.LeftButton) {
                if (Network.wirelessConnected)
                return toggleNet();
                if (Network.wiredConnected)
                return;
            }
            if ((mouse.button) == Qt.RightButton) {
                if (Network.wirelessConnected)
                return root.wifiListProc.running = true;
                if (Network.wiredConnected)
                return;
            }

            return;
        }
    }

    Process {
        id: wifiListProc
        command: ["qs", "ipc", "call", "netList", "toggleVisible"]
    }
}
