import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
    anchors.verticalCenter: parent.verticalCenter
    spacing: 6
    Layout.rightMargin: 2
    Repeater {
        model: Hyprland.workspaces.values.filter(w => w.id > 0)
        Rectangle {
            id: wsRect
            required property var modelData
            property bool isActive: Hyprland.focusedWorkspace?.id === modelData.id
            
            radius: 5
            implicitWidth: isActive ? wsNum.contentWidth + 50 : wsNum.contentWidth + 20
            implicitHeight: isActive ? 26 : 24
            color: isActive ? "#ccfaebd7" : "#cc3d3636"

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 50
                    easing.type: Easing.InQuart
                }
            }

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: 50
                    easing.type: Easing.InQuart
                }
            }

            Behavior on color {
                ColorAnimation { duration: 200 }
            }

            Text {
                id: wsNum
                anchors {
                    centerIn: parent
                }
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
