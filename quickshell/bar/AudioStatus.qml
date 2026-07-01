pragma ComponentBehavior: Bound;
import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Pipewire
import QtQuick.Controls

import qs.bar
import qs.services
import qs.popups

Item {
    id: audioStatus

    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: audioPopup.isOpen = !audioPopup.isOpen
    }


    AudioPopup{
        id: audioPopup
        anchor.item: audioStatus
        anchor.adjustment: PopupAdjustment.None
        anchor.edges: Edges.Top
        anchor.margins.left: -200
        anchor.margins.top: 27
    }

    Rectangle { 
		color: "#ccfaebd7"
		implicitWidth: 140
		implicitHeight: 20 
		radius: 2
		clip: true

        Behavior on implicitWidth {
			NumberAnimation {
				duration: 250
				easing.type: Easing.InOut
			}
        }

		RowLayout {
			id: audRow
			anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 4
			Text {
				id: volText
				color: "#ff3d3636"
				text: Audio.volValue + "%"
				font { family: "Sixtyfour"; pixelSize: 10 }
			}
			Text {
				id: volIcon
				color: "#ff3d3636"
				renderType: Text.NativeRendering
                text: Audio.volMuted ? "󰖁" : "󰕾"
                bottomPadding: 2.7
				font { family: "JetBrainsMono Nerd Font Mono"; pointSize: 16 }
            }

            Rectangle { implicitWidth: 1; implicitHeight: 12; anchors.verticalCenter: parent.verticalCenter; color: "#ff3d3636"; radius: 0.5 }

            Text {
                id: micText
                color: "#ff3d3636"
                text: Audio.micValue + "%"
                font { family: "Sixtyfour"; pixelSize: 10 }
            }
            Text {
                id: micIcon
                color: "#ff3d3636"
                text: Audio.micMuted ? "" : ""
                bottomPadding: 3.5
                font { family: "JetBrainsMono Nerd Font Mono"; pointSize: 20 }
            }
        }
    }
}

