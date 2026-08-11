pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.central.components

ColumnLayout {
    id: mainPanel
    spacing: 20
    Layout.fillWidth: true
    Layout.fillHeight: true
    anchors.horizontalCenter: parent.horizontalCenter
    opacity: mainPanel.visible ? 1 : 0

    GridLayout {
        id: setGrid
        columns: 2
        rows: 2
        rowSpacing: 6
        columnSpacing: 6
        Layout.topMargin: 10
        readonly property int rectWidth: 135
        readonly property int rectHeight: 50
        NetButton {}
        BtButton {}
        PerfButton {}
        DndButton {}
    }
            
    ColumnLayout {
        id: sliderColumn

        property int barCount: 11
        property real minHeight: 4
        property real maxHeight: 14

        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
        Rectangle {
            implicitWidth: 275
            implicitHeight: 80
            color: "transparent"
            radius: 10 

            RowLayout {
                spacing: 23.5
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: sliderColumn.barCount
                    delegate: Rectangle {
                        anchors.top: parent.top
                        required property int index
                        implicitWidth: 2
                        implicitHeight: (index%2 === 0) ? sliderColumn.maxHeight : sliderColumn.minHeight
                        radius: 1
                        color: root.sColor
                    }
                }
            }
                    
            AudioSlider {
                value: Audio.sinkVolume
                onMoved: Audio.setSinkVolume(value)
            }
        }
        Rectangle {
            implicitWidth: 275
            implicitHeight: 80
            color: "transparent"
            radius: 10

            RowLayout {
                spacing: 23.5
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                Repeater {
                    model: sliderColumn.barCount
                    delegate: Rectangle {
                        anchors.bottom: parent.bottom
                        required property int index
                        implicitWidth: 2
                        implicitHeight: (index%2 === 0) ? sliderColumn.maxHeight : sliderColumn.minHeight
                        radius: 1
                        color: root.sColor
                    }
                }
            }

            AudioSlider {
                value: Audio.sourceVolume
                onMoved: Audio.setSourceVolume(value)
            }
        }
    }

    NotificationArea {}

    Behavior on opacity {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuad }
    }
}
