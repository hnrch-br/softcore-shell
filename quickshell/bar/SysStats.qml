pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Widgets
import QtQuick.Layouts
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
            Rectangle {
                z: 1
                implicitHeight: 20
                implicitWidth: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 5
                color: Qt.alpha(root.sColor, 0.7)
                IconImage {
                    z: 2
                    id: iconCPU
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 0.25
                    source: Qt.resolvedUrl("../assets/components/cpu.svg")
                    implicitSize: 14
                    backer.fillMode: Image.PreserveAspectFit
                    backer.smooth: true
                    mipmap: true
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
            Rectangle {
                z: 1
                implicitHeight: 20
                implicitWidth: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 5
                color: Qt.alpha(root.sColor, 0.7)
                IconImage {
                    z: 2
                    id: iconGPU
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 0.1
                    source: Qt.resolvedUrl("../assets/components/gpu.svg")
                    implicitSize: 14
                    backer.fillMode: Image.PreserveAspectFit
                    backer.smooth: true
                    mipmap: true
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
            Rectangle {
                z: 1
                implicitHeight: 20
                implicitWidth: 20
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                radius: 5
                color: Qt.alpha(root.sColor, 0.7)
                IconImage {
                    z: 2
                    id: iconMEM
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenterOffset: 0.2
                    source: Qt.resolvedUrl("../assets/components/memory-stick.svg")
                    implicitSize: 14
                    backer.fillMode: Image.PreserveAspectFit
                    backer.smooth: true
                    mipmap: true
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
