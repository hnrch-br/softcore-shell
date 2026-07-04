pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import qs.services

PopupWindow {
    id: root

    property color mColor: "#473d3636"
    property color sColor: "#ccfaebd7"

    implicitWidth: 260
    implicitHeight: 300
    color: "transparent"

    property bool isOpen: false
    visible: root.isOpen ? true : false

    HyprlandFocusGrab {
        active: root.isOpen
        windows: [root]
        onCleared: {
           closeAnim.start(); 
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.isOpen
        onActivated: closeAnim.start();
    }

    Rectangle {
        id: sysPopupOuter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.visible ? parent.height : 0
        implicitWidth: root.visible ? parent.width - 35 : 0
        bottomLeftRadius: 15
        bottomRightRadius: 15
        color: root.mColor
        opacity: root.visible ? 1 : 0

        Corner {
            x: -radius
            rotation: 90
        }
        Rectangle {
            id: processes
            implicitWidth: root.visible ? parent.width - 20 : 0
            implicitHeight: root.visible ? parent.height - 10 : 0
            opacity: root.visible ? 1 : 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            radius: 5
            color: root.sColor
            Behavior on implicitHeight {
                NumberAnimation { duration: 100 }
            }
            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
            Behavior on implicitWidth {
                NumberAnimation { duration: 100 }
            }
        }

        Behavior on implicitHeight {
            NumberAnimation { duration: 100 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        Behavior on implicitWidth {
            NumberAnimation { duration: 100 }
        }
    }

    component Corner: Shape {
        id: corner
        preferredRendererType: Shape.CurveRenderer

        property real radius: 20

        ShapePath {
            strokeWidth: 0
            fillColor: root.mColor

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

    SequentialAnimation {
        id: closeAnim
        ParallelAnimation {
            NumberAnimation {
                target: sysPopupOuter
                property: "implicitHeight"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: sysPopupOuter
                property: "opacity"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: sysPopupOuter
                property: "implicitWidth"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: processes
                property: "implicitHeight"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: processes
                property: "opacity"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: processes
                property: "implicitWidth"
                duration: 150
                to: 0
                easing.type: Easing.OutQuad
            }
        }
        ScriptAction {
            script: {
                root.isOpen = false;
            }
        }
    }
}
