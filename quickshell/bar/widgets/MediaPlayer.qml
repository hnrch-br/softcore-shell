import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Shapes
import Quickshell.Io
import QtQuick.Controls

RowLayout {
	id: root
	Process {
		id: cavaProcess
		command: ["cava", "-p", "/home/hnrch/.config/cava/config"]
		running: true
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				var line = data.trim()
				if (line === "") return
				var values = data.trim().split(";").filter(v => v !== "")
				cavaValues = values.slice(0, 10).map(v => parseInt(v) / 100.0)
			}
		}
	}

	onIsPlayingChanged: {
		if (!isPlaying) {
		marqueeAnim.stop()
		trackOutput.x = 0
		} else {
			marqueeContainer.restartMarquee()
		}
	}

	property var player: Mpris.players.values.length > 0 ? Mpris.players.values[0] : null
    property bool isPlaying: player !== null && player.playbackState === MprisPlaybackState.Playing
    property string trackTitle: isPlaying ? player.trackTitle : ""
	property string trackArtist: isPlaying ? player.trackArtist : ""
	property var mediaPlaying: isPlaying ? trackArtist + ": " + trackTitle : "No media"
	property var cavaValues: [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	Rectangle {	
		implicitWidth: childrenRect.width + 30
		implicitHeight: trackOutput.contentHeight
		radius: 25
		clip: true
		color: "#ccfaebd7"
		Behavior on implicitWidth {
			NumberAnimation {
				duration: 240
				easing.type: Easing.InOutQuad
			}
		}

		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			spacing: 8
			Item {
				id: marqueeContainer
				anchors.left: parent.left
				implicitWidth: isPlaying ? 135 : trackOutput.contentWidth + 8
				height: trackOutput.contentHeight
				clip: true
				layer.enabled: true
				Text {
					id: trackOutput
					text: mediaPlaying
					color: "#ff3d3636"
					font { family: "Monospace"; weight: Font.Bold; pixelSize: 16 }
				}

				NumberAnimation {
					id: marqueeAnim
					target: trackOutput
					property: "x"
					from: marqueeContainer.width
					to: -trackOutput.contentWidth
					duration: trackOutput.width * 25
					loops: Animation.Infinite
					running: false
				}
				
				onWidthChanged: { 
					if (isPlaying) restartMarquee()
				
				}
				function restartMarquee() {
					marqueeAnim.stop()
					trackOutput.x = marqueeContainer.width
					marqueeAnim.start()
				}

				Connections {
					target: trackOutput
					function onContentWidthChanged() {
						if (isPlaying) marqueeContainer.restartMarquee()
					}
				}
				Connections {
					target: root
					function onMediaPlayingChanged() {
						if (!isPlaying) marqueeContainer.width = trackOutput.contentWidth + 8
					}
				}
			}

			Text {
				id: lengthText
				text: lengthMedia
				color: "#ff3d3636"
				font { family: "Monospace"; pixelSize: 12 }
			}

			Row {
				spacing: 3
				height: 16
				anchors.bottom: parent.bottom
				bottomPadding: 2
				anchors.right: parent.right
				Repeater {
					model: cavaValues.length
					Rectangle {
						implicitWidth: 2
						height: Math.max(2, Math.min(cavaValues[index] * 100, 100))
						color: "#ff3d3636"
						anchors.bottom: parent.bottom
					}
				}
			}
		}
		Layout.rightMargin: 5
	}
}

