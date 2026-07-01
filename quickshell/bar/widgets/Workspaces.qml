import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts

RowLayout {
	anchors.top: parent.top
	Repeater {
		model: 5
		Rectangle {
			id: wsRect
			property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
	   		property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
			radius: 5
			implicitWidth: isActive ? wsNum.contentWidth + 50 : wsNum.contentWidth + 20
			implicitHeight: wsNum.contentHeight
			color: isActive ? "#ccfaebd7" : "#cc3d3636"
			Layout.rightMargin: 4

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
				text: index + 1
	    		color: isActive ? "#ff3d3636" : "#fffaebd7"
	    		font { family: "Bytesized"; pixelSize: isActive ? 20 : 18 ; weight: isActive ? 650 : Font.Normal }
			}

	    	MouseArea {
	    		anchors.fill: parent
				cursorShape: Qt.PointingHandCursor
				hoverEnabled: true
				onClicked: Hyprland.dispatch(`hl.dsp.focus({ workspace = ${index + 1} })`)
    		}
		}
	}
}
