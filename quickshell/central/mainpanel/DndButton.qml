import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Controls

import qs.services

Rectangle {
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: dndMA.containsMouse
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Notifications.doNotDisturb 
        ? Qt.tint(Qt.alpha(root.sColor, 0.8), "#af895f")
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: dndMA.containsMouse 
        ? "transparent" 
        : Qt.alpha(root.sColor, 0.4)

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
        anchors.leftMargin: 10
        spacing: 15
        IconImage {
            source: Qt.resolvedUrl(
                "../../assets/central/" +
                (Notifications.doNotDisturb ? "do_not_disturb_on" : "do_not_disturb_off")+
                ".svg"
            )
            implicitSize: 28
            backer.layer.smooth: true
            backer.layer.enabled: true
            backer.layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: (Notifications.doNotDisturb && dndMA.containsMouse)
                    ? Qt.alpha(root.mColor, 1.0)
                    : (Notifications.doNotDisturb)
                    ? Qt.darker(root.mColor, 0.8)
                    : root.sColor
            }
        }

        Text {
            id: dndStatus
            text: Notifications.doNotDisturb ? "On" : "Off"
            font {
                family: "Pixelify Sans"
                pixelSize: 14
            }
            color: (Notifications.doNotDisturb && dndMA.containsMouse)
                ? Qt.alpha(root.mColor, 1.0)
                : (Notifications.doNotDisturb)
                ? Qt.darker(root.mColor, 0.8)
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
        onClicked: Notifications.toggleDnd()
    }
}
