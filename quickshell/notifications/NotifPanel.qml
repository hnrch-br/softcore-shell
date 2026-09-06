import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Wayland
import QtQuick.Shapes

import qs.services

Scope {
    id: root

    readonly property color mColor: "#faebd7"
    readonly property color sColor: "#3b2e2a"

    PanelWindow {
        id: notifpanel

        property bool hasPopup: NotifServer.popups.rowCount() > 0
        visible: false

        implicitWidth: 400
        implicitHeight: 300

        color: "transparent"

        anchors.top: true
        margins.top: -35

        Connections {
            target: NotifServer.popups

            function onRowsInsterted(): void {
                notifpanel.hasPopup = NotifServer.popups.rowCount() > 0
            }

            function onRowsRemoved(): void {
                notifpanel.hasPopup = NotifServer.popups.rowCount() > 0
            }

            function onModelReset(): void {
                notifpanel.hasPopup = NotifServer.popups.rowCount() > 0
            }
        }

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Normal

        Rectangle {
            id: notiflist
            
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }

            implicitWidth: parent.width - 50
            implicitHeight: parent.height

            color: Qt.tint(Qt.alpha(root.mColor, 1.0), "#d6c5b2")
            bottomLeftRadius: 10
            bottomRightRadius: 10

            Corner {
                id: leftCorner
                anchors.left: notiflist.left
                anchors.leftMargin: -radius
                rotation: 90
            }

            Corner {
                id: rightCorner
                anchors.right: notiflist.right
                anchors.rightMargin: -radius
            }
        }
    }

    component Corner: Shape {
        id: corner
        preferredRendererType: Shape.CurveRenderer

        property real radius: 25

        ShapePath {
            strokeWidth: 0
            fillColor: Qt.tint(Qt.alpha(root.mColor, 1.0), "#d6c5b2")

            startX: corner.radius

            PathArc {
                relativeX: -corner.radius
                relativeY: corner.radius
                radiusX: corner.radius
                radiusY: corner.radius
                direction: PathArc.Counterclockwise
            }

            PathLine {
                relativeX: 0
                relativeY: -corner.radius
            }
            PathLine {
                relativeX: corner.radius
                relativeY: 0
            }
        }
    }
}
