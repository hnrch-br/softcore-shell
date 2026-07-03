pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import qs.services

PopupWindow {
    id: root

    implicitWidth: 255
    implicitHeight: 300
    color: "transparent"

    property bool isOpen: false
    visible: isOpen ? true : false

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
        implicitWidth: parent.width - 25
        bottomLeftRadius: 15
        bottomRightRadius: 15
        color: "#823d3636"
        opacity: root.visible ? 1 : 0

        Corner {
            x: -radius
            rotation: 90
        }

        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            spacing: 2
            Rectangle {
                id: cpuPanel
                implicitWidth: 68
                implicitHeight: root.visible ? 290 : 0
                opacity: root.visible ? 1 : 0
                radius: 5
                color: "#c8bcac"
    
                Behavior on implicitHeight {
                    NumberAnimation { duration: 100 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }
            Rectangle {
                id: gpuPanel
                implicitWidth: 68
                implicitHeight: root.visible ? 290 : 0
                opacity: root.visible ? 1 : 0
                radius: 5
                color: "#c8bcac"

                Behavior on implicitHeight {
                    NumberAnimation { duration: 100 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }

            Rectangle {
                id: memPanel
                implicitWidth: 68
                implicitHeight: root.visible ? 290 : 0
                opacity: root.visible ? 1 : 0
                radius: 5
                color: "#c8bcac"
 
                Behavior on implicitHeight {
                    NumberAnimation { duration: 100 }
                }
                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }
        }

        Behavior on implicitHeight {
            NumberAnimation { duration: 100 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
    }

    component Corner: Shape {
        id: corner
        preferredRendererType: Shape.CurveRenderer

        property real radius: 20

        ShapePath {
            strokeWidth: 0
            fillColor: "#823d3636"

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
                target: cpuPanel
                property: "implicitHeight"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: cpuPanel
                property: "opacity"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: gpuPanel
                property: "implicitHeight"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: gpuPanel
                property: "opacity"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: memPanel
                property: "implicitHeight"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: memPanel
                property: "opacity"
                duration: 200
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
