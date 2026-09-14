import QtQuick
import Quickshell
import Quickshell.Widgets
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Controls

import qs.services

RowLayout {
    id: wtRoot

    Layout.alignment: Qt.AlignVCenter

    Rectangle {
        bottomLeftRadius: 25
        topLeftRadius: 25
        bottomRightRadius: 2
        topRightRadius: 2
        implicitWidth: 70
        implicitHeight: 20

        color: root.sColor
        RowLayout {
            anchors.centerIn: parent
            spacing: 1
            Text {
                id: temps
                text: Weather.ready
                    ? Weather.tempCur + "°"
                    : "..."
                color: root.mColor
                font { family: "Sixtyfour"; pixelSize: 10 }
            }
            IconImage {
                id: icons
                implicitSize: 14
                backer.fillMode: Image.PreserveAspectCrop
                backer.smooth: true 
                source: Weather.ready
                    ? Qt.resolvedUrl(
                        "../assets/weather/"
                        + Weather.glyph(Weather.codeCur, Weather.isDay)
                        + ".svg"
                    )
                    : ""
                asynchronous: true
            } 
        }
    }
}
