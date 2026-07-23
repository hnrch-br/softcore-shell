pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

Item {
    id: root

    readonly property var workspaces: Hyprland.workspaces.values.filter(w => w.id > 0)
    readonly property int focusedWorkspace: Hyprland.focusedWorkspace?.id ?? -1

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight

    Behavior on implicitWidth {
        NumberAnimation { duration: 80 }
    }
    
    clip: true

    RowLayout {
        id: wsRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6 
        Repeater {
            model: root.workspaces
            delegate: Rectangle {
                id: wsRect 
                required property var modelData
                property bool isActive: modelData.id === root.focusedWorkspace

                radius: 5
                implicitWidth: wsRect.isActive ? 56 : 30
                implicitHeight: wsRect.isActive ? 26 : 24
                color: wsRect.isActive ? "#ccfaebd7" : "#cc3d3636"

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 50
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 50
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation { 
                        duration: 200;
                        easing.type: Easing.OutQuad
                    }
                }

                Text {
                    id: wsNum
                    anchors.centerIn: parent
                    leftPadding: 2.3
                    text: wsRect.modelData.id
                    color: wsRect.isActive ? "#ff3d3636" : "#fffaebd7"
                    font { family: "Bytesized"; pixelSize: wsRect.isActive ? 20 : 18 ; weight: wsRect.isActive ? 650 : Font.Normal }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${wsRect.modelData.id} })`)
                }
            }
        }
    }
}
