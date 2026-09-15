import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services

Rectangle {
    id: notifArea
    readonly property color backColor: "#573a2f"
    implicitWidth: 275
    implicitHeight: 140
    radius: 10
    clip: true
    color: notifArea.backColor

    ListView {
        anchors.fill: parent
        model: Notifications.popups
        clip: true
        verticalLayoutDirection: ListView.TopToBottom
        delegate: Rectangle {
            ColumnLayout {

            }
        }
    }
}
