import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import Quickshell.Widgets
import QtQuick.Layouts
import Quickshell.Io

import qs.services

Rectangle {
    id: btRect
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: btMA.containsMouse
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : (Bluetooth.enabled || Bluetooth.activeDevice) 
        ? Qt.tint(Qt.alpha(root.sColor, 0.8), "#af895f")
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: btMA.containsMouse 
        ? "transparent" 
        : Qt.alpha(root.sColor, 0.4)
    clip: true
    
    Behavior on color {
        ColorAnimation {
            duration: 150
            easing.type: Easing.OutQuad
        }
    }
    Behavior on border.color {
        ColorAnimation {
            duration: 100
            easing.type: Easing.OutQuad
        }
    }
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.leftMargin: 10
        spacing: 15
        
        IconImage {
            source: Qt.resolvedUrl(
                "../../assets/central/" +
                Bluetooth.btIcon +
                ".svg"
            )
            implicitSize: 28
            backer.layer.smooth: true
            backer.layer.enabled: true
            backer.layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: (Bluetooth.enabled && btMA.containsMouse)
                    ? Qt.alpha(root.mColor, 1.0)
                    : (Bluetooth.enabled)
                    ? Qt.darker(root.mColor, 0.8)
                    : root.sColor
            }
        }
        Text {
            id: btDevice
            text: Bluetooth.deviceName
            Layout.fillWidth: true
            font {
                family: "Pixelify Sans" 
                pixelSize: 14
            }
            color: (Bluetooth.enabled && btMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : (Bluetooth.enabled)
                ? Qt.darker(root.mColor, 0.8)
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
        onClicked: Bluetooth.toggleEnabled()
        onPressAndHold: btListProc.running = true
    }

    Process {
        id: btListProc
        command: ["qs", "ipc", "call", "btList", "toggleVisible"]
    }
}
