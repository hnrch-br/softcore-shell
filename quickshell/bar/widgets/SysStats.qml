import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

RowLayout {

	property int cpuUsage: 0
	property var lastCpuIdle: 0
	property var lastCpuTotal: 0
	property int memUsage: 0
	Rectangle {
		implicitWidth: childrenRect.width + 16
		implicitHeight: childrenRect.height
		color: "#ccfaebd7"
		radius: 25
		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			Text { 
				id: textCPU
				text: cpuUsage + "%"
				color: "#ff3d3636"
        		font { family: "Monospace"; weight: Font.Bold; pixelSize: 16 }
			}
			Text {
				id: iconCPU
				text: "memory_alt"
				color: "#ff3d3636"
				font { family: "Material Symbols Outlined"; pixelSize: 16 }
			}
		}
		Layout.rightMargin: 5
	}
	Rectangle {
		implicitWidth: childrenRect.width + 15
		implicitHeight: childrenRect.height
		color: "#ccfaebd7"
		radius: 25
		RowLayout {
			anchors.horizontalCenter: parent.horizontalCenter
			anchors.verticalCenter: parent.verticalCenter
			Text {
				id: textMEM
				text: memUsage + "%"
				color: "#ff3d3636"
				font { family: "Monospace"; weight: Font.Bold ;pixelSize: 16 }
			}
			Text {
				id: iconMEM
				text: "storage"
				color: "#ff3d3636"
				font { family: "Material Symbols Outlined"; pixelSize: 16 }
			}
		}
		Layout.rightMargin: 5
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
	
	// Timer
	Timer {
	    interval: 15000
	    running: true
	    repeat: true
	    onTriggered: {
	        cpuProc.running = true
	        memProc.running = true
    	}
	}
}
