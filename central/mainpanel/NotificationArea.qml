import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets
import qs.services

Rectangle {
    id: notifArea
    readonly property color backColor: "#573a2f"
    implicitWidth: 275
    implicitHeight: 140
    radius: 10
    clip: true
    color: notifArea.backColor
}
