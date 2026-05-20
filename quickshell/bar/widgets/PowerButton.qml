import Quickshell
import QtQuick
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes

Rectangle {
	implicitWidth: powerButton.contentWidth + 15
	implicitHeight: powerButton.contentHeight + 4
	radius: 25
	color: "#ccfaebd7"
	
	Text {
		id: powerButton
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.verticalCenter: parent.verticalCenter
		text: "power_settings_circle"
		font { family: "Material Symbols Outlined"; pixelSize: 16; bold: true }
	}	
	
	MouseArea {
		anchors.fill: parent
		cursorShape: Qt.PointingHandCursor
		onClicked: {
			NumberAnimation {
				id: trayAnim
				target: powerTray
			}

		}
	}

	
}
