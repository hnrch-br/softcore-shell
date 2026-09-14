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
    id: sysRoot
    
    implicitWidth: childrenRect.width
    implicitHeight: childrenRect.height 

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
            implicitWidth: sysRoot.rectsWidth
            implicitHeight: 20
            color: root.sColor
            radius: 2
            clip: true 
            RowLayout {
                z: 1
                id: cpuRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    id: iconCPU
                    Layout.preferredWidth: 14
                    Layout.preferredHeight: 14
                    source: Qt.resolvedUrl("../assets/components/cpu.svg")
                    sourceSize.width: 14
                    sourceSize.height: 14
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                spacing: sysRoot.barSpacing
                Repeater {
                    model: Math.round((System.cpuUsage / 100) * sysRoot.maxBars)
                    delegate: Rectangle {
                        radius: 1
                        implicitWidth: sysRoot.barWidth
                        implicitHeight: sysRoot.barHeight
                        Layout.alignment: Qt.AlignVCenter
                        color: Qt.tint(Qt.alpha(root.mColor, 0.8), "#a67b5b")
                    }
                }
            }
        }

        Rectangle {
            implicitWidth: sysRoot.rectsWidth
            implicitHeight: 20
            color: root.sColor
            radius: 2
            clip: true
            RowLayout {
                z: 1
                id: gpuRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter 
                Image {
                    id: iconGPU
                    Layout.preferredWidth: 14
                    Layout.preferredHeight: 14
                    source: Qt.resolvedUrl("../assets/components/gpu.svg")
                    sourceSize.width: 14
                    sourceSize.height: 14
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                spacing: sysRoot.barSpacing
                Repeater {
                    model: Math.round((System.gpuUsage / 100) * sysRoot.maxBars)
                    delegate: Rectangle {
                        radius: 1
                        implicitWidth: sysRoot.barWidth
                        implicitHeight: sysRoot.barHeight
                        Layout.alignment: Qt.AlignVCenter
                        color: Qt.tint(Qt.alpha(root.mColor, 0.8), "#a67b5b")
                    }
                }
            }
        }

        Rectangle {
            implicitWidth: sysRoot.rectsWidth
            implicitHeight: 20
            color: root.sColor
            radius: 2
            clip: true
            RowLayout {
                z: 1
                id: ramRow
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Image {
                    id: iconMEM
                    Layout.preferredWidth: 14
                    Layout.preferredHeight: 14
                    source: Qt.resolvedUrl("../assets/components/memory-stick.svg")
                    sourceSize.width: 14
                    sourceSize.height: 14
                    fillMode: Image.PreserveAspectFit
                    smooth: true
                }
            }
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 1
                spacing: sysRoot.barSpacing
                Repeater {
                    model: Math.round((System.memUsage / 100) * sysRoot.maxBars)
                    delegate: Rectangle {
                        radius: 1
                        implicitWidth: sysRoot.barWidth
                        implicitHeight: sysRoot.barHeight
                        Layout.alignment: Qt.AlignVCenter
                        color: Qt.tint(Qt.alpha(root.mColor, 0.8), "#a67b5b")
                    }
                }
            }
        }
    }
}
