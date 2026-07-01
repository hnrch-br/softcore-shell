import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

import qs.services

PopupWindow {
    id: root
    
    implicitWidth: 230
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
        implicitWidth: parent.width
        bottomLeftRadius: 15
        bottomRightRadius: 15
        color: "#823d3636"
        opacity: root.visible ? 1 : 0

        Rectangle {
            id: sysPopupInner
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            implicitHeight: root.visible ? 290 : 0
            implicitWidth: 210
            color: "#ccfaebd7"
            opacity: root.visible ? 1 : 0
            radius: 15

            Behavior on implicitHeight {
                NumberAnimation { duration: 100}
            }

            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
        }

        Behavior on implicitHeight {
            NumberAnimation { duration: 100 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 100 }
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
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: sysPopupOuter
                property: "opacity"
                duration: 100
                to: 0
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: sysPopupInner
                property: "implicitHeight"
                duration: 100
                to: 0
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: sysPopupInner
                property: "opacity"
                duration: 100
                to: 0
                easing.type: Easing.InOutQuad
            }
        }
        ScriptAction {
            script: {
                root.isOpen = false;
            }
        }
    }
}
