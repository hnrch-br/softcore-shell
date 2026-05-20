import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
	property string weatherText: "..."
	property string weatherIconText: "..."
	Rectangle {
		implicitWidth: childrenRect.width + 15
		implicitHeight: childrenRect.height
		color: "#ccfaebd7"
		radius: 25
		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.top: parent.top
			Text {
				id: weatherOutput
				text: weatherText
				color: "#ff3d3636"
				font { family: "Monospace"; weight: Font.Bold; pixelSize: 16 }
			}
			Text {
				id: weatherIconOutput
				text: weatherIconText
				color: "#ff3d3636"
				font { family: "Material Symbols Outlined"; pixelSize: 16 }
			}
		}	
		Layout.rightMargin: 5
	}
	Process {
		id: weatherProc
		command: ["/home/hnrch/.config/quickshell/bar/widgets/scripts/weather.sh"]

		stdout: SplitParser {
			onRead: data => {
				var weather = JSON.parse(data)
				weatherText = weather.text
				weatherIconText = weather.icon
			}
		}
		Component.onCompleted: running = true
	}
	Timer {
		interval: 3600000
		running: true
		repeat: true
		onTriggered: weatherProc.running = true
	}
}
