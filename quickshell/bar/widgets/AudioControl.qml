import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Pipewire

RowLayout {
	signal trayToggled
	PwObjectTracker {
    	objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]	
	}
    property var sink: Pipewire.defaultAudioSink
	property var source: Pipewire.defaultAudioSource
	property bool volMuted: (sink && sink.audio) ? sink.audio.muted : false
	property bool micMuted: (source && source.audio) ? source.audio.muted : false
	property string volStr: {
		const vol = (sink && sink.audio) ? sink.audio.volume : null
		return vol != null && !isNaN(vol) ? `${Math.floor(vol * 100)}%` : "--"	
	}
	property string micStr: {
		const mic = (source && source.audio) ? source.audio.volume : null
		return mic != null && !isNaN(mic) ? `${Math.floor(mic * 100)}%` : "--"
	}
	
	Rectangle { 
		color: "#ccfaebd7"
		implicitWidth: childrenRect.width + 15
		implicitHeight: childrenRect.height
		radius: 25
		RowLayout {
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
			Text {
				id: separator
				color: "#ff3d3636"
				text: "︲"
				font { family: "Monospace"; weight: Font.Bold; pixelSize: 16 }
			}
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
		MouseArea {
			anchors.fill: parent
			cursorShape: Qt.PointingHandCursor
			hoverEnabled: true
			onClicked: trayToggled()
		}
		Layout.rightMargin: 5
	}
}

