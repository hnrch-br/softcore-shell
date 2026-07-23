import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

import qs.services

Rectangle {
    id: btRect
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: (Bluetooth.enabled || Bluetooth.activeDevice)
        ? Qt.tint(Qt.alpha(root.sColor, 0.6), "#a67b5b")
        : btMA.containsMouse 
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b") 
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: btMA.containsMouse 
        ? "transparent" 
        : Qt.alpha(root.sColor, 0.4)
    clip: true
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        spacing: 15
        
        Text {
            id: btIcon
            text: Bluetooth.btIcon
            font {
                family: "Material Symbols Outlined"
                pointSize: 16.7 
            }
            color: btMA.containsMouse 
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
        }

        Text {
            id: btDevice
            text: Bluetooth.deviceName
            Layout.fillWidth: true
            font {
                family: "Pixelify Sans" 
                pixelSize: 14
            }
            color: btMA.containsMouse
                ? Qt.alpha(root.mColor, 1.0)
                : root.sColor
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    MouseArea {
        id: btMA
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if ((mouse.button) == Qt.LeftButton){
                return Bluetooth.toggleEnabled();
            }
            if ((mouse.button == Qt.RightButton)) {
                if (Bluetooth.defaultAdapter)
                return wifiListProc.running = true;
            }

            return;
        }
    }

    Process {
        id: wifiListProc
        command: ["qs", "ipc", "call", "btList", "toggleVisible"]
    }
}
