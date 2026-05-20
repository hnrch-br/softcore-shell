import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io

Text {
	id: clock
	text: Qt.formatDateTime(new Date(), "HH:mm")
	color: "#ff3d3636"
	font {family: "Google Sans Bold"; pixelSize: 28; bold: true }
	Timer {
		interval: 1000
		running: true
		repeat: true
		onTriggered: clock.text = Qt.formatDateTime(new Date(), "HH:mm")
   	}
}

