pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

Item {
    id: root

    readonly property var workspaces: {
        try { 
            Hyprland.workspaces.values
                .filter(workspace => workspace.id >= 0)
                .sort((a, b) => a.id - b.id)
        } catch (e) {
            return;
        }
    }
    readonly property var toplevels: Hyprland.toplevels
    readonly property int minWorkspaces: 5

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight
    clip: true

    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 50
            easing.type: Easing.OutQuad
        }
    }

    Connections {
        target: Hyprland
        function onRawEvent(event: HyprlandEvent): void {
            const n = event.name;
            if (n.endsWith("v2")) return;

            if (["workspace", "moveworkspace", "activespecial", "focusedmon"].includes(n)) {
                Hyprland.refreshWorkspaces();
            }
            if (["openwindow", "closewindow", "movewindow"].includes(n)) {
                Hyprland.refreshToplevels();
            }
            if (n.includes("workspace")) return Hyprland.refreshWorkspaces();
            if (n.includes("window") || ["fullscreen", "changefloatingmode", "minimize"].includes(n));
        }
    }

    RowLayout {
        id: wsRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6 
        Repeater {
            id: wsRepeater
            model: ScriptModel {
                values: root.workspaces
            }

            delegate: Rectangle {
                id: wsRect 
                required property var modelData
                property bool isFocused: wsRect.modelData.focused

                radius: 5
                implicitWidth: wsRect.isFocused ? 56 : 30
                implicitHeight: wsRect.isFocused ? 26 : 24
                color: wsRect.isFocused
                    ? "#ccfaebd7"
                    : "#cc3d3636"

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
                        duration: 50;
                        easing.type: Easing.OutQuad
                    }
                }

                Text {
                    id: wsNum
                    anchors.centerIn: parent
                    leftPadding: 2.3
                    text: wsRect.modelData.id
                    color: wsRect.isFocused
                        ? "#ff3d3636"
                        : "#fffaebd7"
                    font { 
                        family: "Bytesized"
                        pixelSize: wsRect.isFocused 
                            ? 20
                            : 18
                        weight: wsRect.isFocused
                            ? 650 
                            : Font.Normal
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: { 
                        Hyprland.dispatch(`hl.dsp.focus(
                            { workspace = ${wsRect.modelData.id} }
                        )`)
                    }
                }
            }
        }
    }
}
