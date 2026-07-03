import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

import qs.services
import qs.popups

Item {
    id: root
    
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height

    SysPopup {
        id: sysPopup
        anchor {
            item: root
            edges: Edges.Top
            adjustment: PopupAdjustment.None
            margins.left: -sysPopup.implicitWidth
            margins.top: 27
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            sysPopup.isOpen = !sysPopup.isOpen
        }
    }

    RowLayout {
        spacing: 2
        Rectangle {
            implicitWidth: 68
            implicitHeight: 20
            color: "#ccfaebd7"
            radius: 2
            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InQuad
                }
            }
            RowLayout {
                id: cpuRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Text { 
                    id: textCPU
                    text: System.cpuUsage + "%"
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
            radius: 2
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
                    text: System.gpuUsage + "%"
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
            topLeftRadius: 2
            bottomLeftRadius: 2
            bottomRightRadius: 25
            topRightRadius: 25
            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 250
                    easing.type: Easing.InQuad
                }
            }
            RowLayout {
                id: ramRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: textMEM
                    text: System.memUsage + "%"
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
    }
}
