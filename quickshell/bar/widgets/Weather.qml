import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Io

RowLayout {
	property string weatherText: "..."
	property string weatherIconText: "..."
	Rectangle {
		implicitWidth: 96
		implicitHeight: 20
		color: "#ccfaebd7"
		radius: 25
        RowLayout {
   			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			Text {
				id: weatherOutput
				text: weatherText
				color: "#ff3d3636"
                font { family: "Sixtyfour"; pixelSize: 10 }
			}
			Text {
				id: weatherIconOutput
				text: weatherIconText
                color: "#ff3d3636"
				renderType: Text.NativeRendering
				font { family: "Material Symbols Outlined"; pointSize: 10.4 }
			}
		}	
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
