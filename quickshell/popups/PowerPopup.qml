import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Controls

PanelWindow {
    id: root

    property color mColor: "#423d3636"
    property color sColor: "#ccfaebd7"

    anchors {
        left: true
        right: true
        bottom: true
        top: true
    }

    exclusionMode: ExclusionMode.Ignore

    color: "transparent"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "powerpopup"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    IpcHandler {
        target: "powerpopup"

        function toggleVisible(): void {
            root.isOpen = !root.isOpen;
        }
    }

    property bool isOpen: false

    Shortcut {
        sequence: "Escape"
        onActivated: root.isOpen = false
    }

    visible: isOpen

    Rectangle {
        id: powerWrapper
        implicitWidth: 330
        implicitHeight: 124
        color: root.mColor
        anchors.centerIn: parent
        radius: 20
        property int size: 100

        RowLayout {
            spacing: 4
            anchors.centerIn: parent
            Rectangle {
                implicitHeight: powerWrapper.size
                implicitWidth: powerWrapper.size
                radius: 18
                color: onoffMA.containsMouse ? Qt.tint(root.sColor, "#cced752b") : root.sColor

                Text {
                    id: onoff
                    text: "power_settings_circle"
                    font { family: "Material Symbols Outlined"; pixelSize: 40 }
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: onoffMA
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Quickshell.execDetached(["systemctl", "poweroff"])
                }
            }
            Rectangle {
                implicitHeight: powerWrapper.size
                implicitWidth: powerWrapper.size
                radius: 18
                color: rebootMA.containsMouse ? Qt.tint(root.sColor, "#cced752b") : root.sColor

                Text {
                    id: reboot
                    text: "replay"
                    font { family: "Material Symbols Outlined"; pixelSize: 40 }
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: rebootMA
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["systemctl", "reboot"])
                }
            }
            Rectangle {
                implicitHeight: powerWrapper.size
                implicitWidth: powerWrapper.size
                radius: 18
                color: quitMA.containsMouse ? Qt.tint(root.sColor, "#cced752b") : root.sColor

                Text {
                    id: quit
                    text: "door_open"
                    font { family: "Material Symbols Outlined"; pixelSize: 40 }
                    anchors.centerIn: parent
                }

                MouseArea {
                    id: quitMA
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Quickshell.execDetached(["hyprshutdown"])
                }
            }
        }
    }
}

