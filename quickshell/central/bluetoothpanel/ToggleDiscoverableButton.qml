import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

import qs.services

Rectangle {
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 89
    implicitHeight: 48
    radius: 5
    color: Bluetooth.discoverable
        ? Qt.tint(Qt.alpha(root.sColor, 0.6), "#a67b5b") 
        : discoverMA.containsMouse 
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Qt.alpha(root.mColor, 0.8)
            
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 15
        IconImage {
            id: discIcon
            implicitSize: 24
            backer.fillMode: Image.PreserveAspectCrop
            backer.smooth: true
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: (Bluetooth.enabled && discoverMA.containsMouse)
                    ? Qt.alpha(root.mColor, 1.0)
                    : Qt.darker(root.sColor, 1.3)
            }
            source: Qt.resolvedUrl("../../assets/central/explore.svg")
            asynchronous: true
        }
        Text {
            text: Bluetooth.discoverStatus
            font {
                family: "Pixelify Sans"
                pixelSize: 15
            }
            color: (Bluetooth.enabled && discoverMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.6)
        }
    }

    MouseArea {
        id: discoverMA
        anchors.fill: parent
        hoverEnabled: Bluetooth.enabled ? true : false
        cursorShape: Bluetooth.enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: Bluetooth.toggleDiscoverable()
    }
}
