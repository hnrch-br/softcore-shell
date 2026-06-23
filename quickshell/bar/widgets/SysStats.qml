import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

RowLayout {
    spacing: 5
	property int cpuUsage: 0
	property var lastCpuIdle: 0
	property var lastCpuTotal: 0
	property int memUsage: 0
	property int gpuUsage: 0
	Rectangle {
		implicitWidth: 68
		implicitHeight: 20
		color: "#ccfaebd7"
		radius: 25
		Behavior on implicitWidth {
			NumberAnimation {
				duration: 250
				easing.type: Easing.InOut
			}
		}
		RowLayout {
			id: cpuRow
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			Text { 
				id: textCPU
				text: cpuUsage + "%"
				color: "#ff3d3636"
                font { family: "Sixtyfour"; pixelSize: 10 }
			}
			Text {
				id: iconCPU
				text: ""
                color: "#ff3d3636"
                font.pointSize: 17.4
                bottomPadding: 3
                font.family: "JetBrainsMono Nerd Font Mono"
			}
		}
	}
	
	Rectangle {
		implicitWidth: 68
		implicitHeight: 20
		color: "#ccfaebd7"
		radius: 25
		Behavior on implicitWidth {
			NumberAnimation {
				duration: 250
				easing.type: Easing.InOut
			}
		}
		RowLayout {
			id: gpuRow
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			Text {
				id: textGPU
				text: gpuUsage + "%"
				color: "#ff3d3636"
				font { family: "Sixtyfour"; pixelSize: 10 }
			}
			Text {
				id: iconGPU
				text: "󰢮"
				color: "#ff3d3636"
                renderType: Text.NativeRendering
                font.pointSize: 18
                bottomPadding: 3.5
                font.family: "JetBrainsMono Nerd Font Mono"
			}
		}
	}

	Rectangle {
		implicitWidth: 68
		implicitHeight: 20
		color: "#ccfaebd7"
		radius: 25
		Behavior on implicitWidth {
			NumberAnimation {
				duration: 250
				easing.type: Easing.InOut
			}
		}
		RowLayout {
			id: ramRow
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			Text {
				id: textMEM
				text: memUsage + "%"
				color: "#ff3d3636"
				font { family: "Sixtyfour"; pixelSize: 10 }
			}
			Text {
				id: iconMEM
				text: ""
				color: "#ff3d3636"
                renderType: Text.NativeRendering
                font.pointSize: 16
                bottomPadding: 2
                font.family: "JetBrainsMono Nerd Font Mono"
			}
		}
	}
	
	// CPU process
	Process {
		id: cpuProc
		command: ["sh", "-c", "head -1 /proc/stat"]
		stdout: SplitParser {
			onRead: data => {
      	 		if (!data) return
       			var p = data.trim().split(/\s+/)
       			var idle = parseInt(p[4]) + parseInt(p[5])
       			var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0)
       			if (lastCpuTotal > 0) {
       			cpuUsage = Math.round(100 * (1 - (idle - lastCpuIdle) / (total - lastCpuTotal)))
       			}
       			lastCpuTotal = total
    	   		lastCpuIdle = idle
   			}
		}
		Component.onCompleted: running = true
	}

	// MEM process
	Process {
   		id: memProc
		command: ["sh", "-c", "free | grep Mem"]
		stdout: SplitParser {
			onRead: data => {
           	if (!data) return
           	var parts = data.trim().split(/\s+/)
           	var total = parseInt(parts[1]) || 1
           	var used = parseInt(parts[2]) || 0
           	memUsage = Math.round(100 * used / total)
			}
		}
   		Component.onCompleted: running = true
	}

	Process {
		id: gpuProc
		command: ["cat", "/sys/class/drm/card1/device/gpu_busy_percent"]
		stdout: SplitParser {
			onRead: data => {
				if (!data) return
				gpuUsage = parseInt(data.trim())
			}
		}
		Component.onCompleted: running = true
	}

	// Timer
	Timer {
	    interval: 5000
	    running: true
	    repeat: true
	    onTriggered: {
	        cpuProc.running = true
			memProc.running = true
			gpuProc.running = true
    	}
	}
}
