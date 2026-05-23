import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Pipewire
import "./trays"

RowLayout {
	PwObjectTracker {
    	objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]	
	}

	property string volStr: ""
	property var volLevel: 0
	property string micStr: ""
	property var micLevel: 0
	property bool volMuted: volLevel === 0
	property bool micMuted: micLevel === 0

	Process {
		id: volProc
		command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var v = data.trim().split(/\s+/)
				volLevel = parseFloat(v[1])
				if (volLevel >= 0) {
					volStr = `${Math.floor(volLevel * 100)}%`
				} else {
					volStr = "0%"
				}
			}
		}
		Component.onCompleted: running = true
	}

	Process {
		id: micProc
		command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SOURCE@"]
		stdout: SplitParser {
			onRead: data => {
			if (!data) return
			var m = data.trim().split(/\s+/)
			micLevel = parseFloat(m[1])
			if (micLevel >= 0) {
				micStr = `${Math.floor(micLevel * 100)}%`
			} else {
					micStr = "0%"
				}
			}
		}
		Component.onCompleted: running = true
	}

	Timer {
		interval: 500
		running: true
		repeat: true
		onTriggered: {
			volProc.running = true
			micProc.running = true
		}
	}

	Rectangle { 
		color: "#ccfaebd7"
		implicitWidth: audRow.implicitWidth + 15
		implicitHeight: audRow.implicitHeight
		radius: 25
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
			Text {
				id: volText
				color: "#ff3d3636"
				text: volStr
				font { family: "Monospace"; weight: Font.Bold; pixelSize: 16 }
			}
			Text {
				id: volIcon
				color: "#ff3d3636"
				text: volMuted ? "volume_off" : "volume_up"
				font { family: "Material Symbols Outlined"; pixelSize: 16 }
			}

			Rectangle { height: 16; width: 2; radius: 2; color: "#803d3636" }

			Text {
				id: micText
				color: "#ff3d3636"
				text: micStr
				font { family: "Monospace"; weight: Font.Bold; pixelSize: 16 }
			}
			Text {
				id: micIcon
				color: "#ff3d3636"
				text: micMuted ? "mic_off" : "mic"
				font { family: "Material Symbols Outlined"; pixelSize: 16 }				
			}
		}
		Layout.rightMargin: 5
	}
}

