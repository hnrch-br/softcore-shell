import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls

import qs.services

RowLayout {
    id: root
    anchors.verticalCenter: parent.verticalCenter

    Rectangle {
        bottomLeftRadius: 25
        topLeftRadius: 25
        bottomRightRadius: 2
        topRightRadius: 2
        implicitWidth: 70
        implicitHeight: 20

        color: "#ccfaebd7"
        RowLayout {
            anchors.centerIn: parent
            spacing: 1
            Text {
                id: temps
                text: Weather.ready
                    ? Weather.tempCur + "°"
                    : "..."
                color: "#ff3d3636"
                font { family: "Sixtyfour"; pixelSize: 10 }
            }
            Text {
                id: icons
                text: Weather.ready
                    ? Weather.glyph(Weather.codeCur, Weather.isDay)
                    : "..."
                color: "#ff3d3636"
                font { family: "Material Symbols Outlined"; pixelSize: 14 }
            }
        }
    }
}
