import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Widgets
import QtQuick.Controls
import Quickshell

import qs.services

Rectangle {
    implicitWidth: setGrid.rectWidth
    implicitHeight: setGrid.rectHeight
    radius: 5
    color: perMA.containsMouse
        ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
        : Qt.alpha(root.mColor, 0.6)
    border.width: 1
    border.color: perMA.containsMouse 
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
                "../../assets/central/bolt_boost.svg"
            )
            implicitSize: 28
            backer.layer.smooth: true
            backer.layer.enabled: true
            backer.layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: perMA.containsMouse
                    ? Qt.alpha(root.mColor, 1.0) 
                    : root.sColor
            }
        }
        Text {
            id: perType 
            text: Perf.profileState
            font { 
                family: "Pixelify Sans"
                pixelSize: {
                    if (perType.text === "Performance") return 11;
                    if (perType.text === "Power Saver") return 11;
                    if (perType.text === "Balanced") return 14;
                }
            }
            color: perMA.containsMouse 
                ? Qt.alpha(root.mColor, 1.0) 
                : root.sColor
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }
    MouseArea {
        id: perMA
        hoverEnabled: true
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Perf.profile()
    }
}
