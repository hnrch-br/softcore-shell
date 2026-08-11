import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import qs.services

ListView {
    id: clipList
    anchors.fill: parent
    spacing: 2
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    anchors.horizontalCenter: parent.horizontalCenter

    delegate: Rectangle {
        id: clipRow

        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: clipList.width
        implicitHeight: 42
        radius: 10

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 10

            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: content
                color: Qt.alpha(root.sColor, 1.0)
                font.family: "Pixelify Sans"
                font.pixelSize: 16
            }
        }
    }
}
