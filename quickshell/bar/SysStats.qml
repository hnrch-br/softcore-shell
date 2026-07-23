pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Hyprland
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

import qs.services

Item {
    id: root
    
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height 

    readonly property color mColor: "#ccfaebd7"
    readonly property color sColor: "#423d3636"

    readonly property int barWidth: 2
    readonly property int barSpacing: 1
    readonly property int barHeight: 18

    readonly property int rectsWidth: 68
    readonly property int availableWidth: rectsWidth - (2 * barSpacing)
    readonly property int maxBars: Math.floor((availableWidth + barSpacing) / (barWidth + barSpacing))

    RowLayout {
        spacing: 2
        Rectangle {
            id: cpuRect
            implicitWidth: root.rectsWidth
            implicitHeight: 20
            color: root.mColor
            radius: 2
            clip: true 
            RowLayout {
                id: cpuRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: iconCPU
        	    	text: ""
                    color: Qt.alpha(root.sColor, 1.0)
                    font.pointSize: 17.4
                    bottomPadding: 3
                    font.family: "JetBrainsMono Nerd Font Mono"
    		    }
            }
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                spacing: root.barSpacing
                Repeater {
                    model: Math.round((System.cpuUsage / 100) * root.maxBars)
                    delegate: Rectangle {
                        radius: 1
                        implicitWidth: root.barWidth
                        implicitHeight: root.barHeight
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.tint(Qt.alpha(root.sColor, 0.8), "#a67b5b")
                    }
                }
            }
        }

        Rectangle {
            implicitWidth: root.rectsWidth
            implicitHeight: 20
            color: root.mColor
            radius: 2
            clip: true
            RowLayout {
                id: gpuRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter 
                Text {
                    id: iconGPU
                    text: "󰢮"
                    color: Qt.alpha(root.sColor, 1.0)
                    font.pointSize: 18
                    bottomPadding: 3
                    font.family: "JetBrainsMono Nerd Font Mono"
                }
            }
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                spacing: root.barSpacing
                Repeater {
                    model: Math.round((System.gpuUsage / 100) * root.maxBars)
                    delegate: Rectangle {
                        radius: 1
                        implicitWidth: root.barWidth
                        implicitHeight: root.barHeight
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.tint(Qt.alpha(root.sColor, 0.8), "#a67b5b")
                    }
                }
            }
        }

        Rectangle {
            implicitWidth: root.rectsWidth
            implicitHeight: 20
            color: root.mColor
            radius: 2
            clip: true
            RowLayout {
                id: ramRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Text {
                    id: iconMEM
                    text: ""
                    color: Qt.alpha(root.sColor, 1.0)
                    font.pointSize: 16
                    bottomPadding: 1.8
                    font.family: "JetBrainsMono Nerd Font Mono"
                }
            }
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                spacing: root.barSpacing
                Repeater {
                    model: Math.round((System.memUsage / 100) * root.maxBars)
                    delegate: Rectangle {
                        radius: 1
                        implicitWidth: root.barWidth
                        implicitHeight: root.barHeight
                        anchors.verticalCenter: parent.verticalCenter
                        color: Qt.tint(Qt.alpha(root.sColor, 0.8), "#a67b5b")
                    }
                }
            }
        }
    }
}
