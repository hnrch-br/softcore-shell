import Quickshell
import QtQuick
import Quickshell.Widgets
import QtQuick.Effects
import QtQuick.Layouts

import qs.services

Rectangle {
    Layout.alignment: Qt.AlignVCenter
    implicitWidth: 89
    implicitHeight: 48
    radius: 5
    color: Bluetooth.enabled 
        ? Qt.tint(Qt.alpha(root.sColor, 0.6), "#a67b5b") 
        : statusMA.containsMouse 
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Qt.alpha(root.mColor, 0.8)
            
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 10
        spacing: 15
        IconImage {
            source: Qt.resolvedUrl(
                "../../assets/central/" +
                Bluetooth.btIcon +
                ".svg"
            )
            implicitSize: 24
            backer.layer.smooth: true
            backer.layer.enabled: true
            backer.layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: statusMA.containsMouse
                    ? Qt.alpha(root.mColor, 1.0) 
                    : root.sColor
            }
        }
        Text {
            text: Bluetooth.btStatus
            font {
                family: "Pixelify Sans"
                pixelSize: 15
            }
            color: statusMA.containsMouse
                ? Qt.alpha(root.mColor, 1.0)
                : Qt.alpha(root.sColor, 0.8)
        }
    }

    MouseArea {
        id: statusMA
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: Bluetooth.toggleEnabled()
    }
}
