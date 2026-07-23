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
        Layout.alignment: Qt.AlignHCenter
        Layout.fillWidth: true
        Layout.fillHeight: true
        Rectangle {
            implicitWidth: 275
            implicitHeight: 80
            color: Qt.alpha(root.mColor, 0.4)
            radius: 10
                    
            AudioSliders {
                value: Audio.sinkVolume
                onMoved: Audio.setSinkVolume(value)
            }
        }
        Rectangle {
            implicitWidth: 275
            implicitHeight: 80
            color: Qt.alpha(root.mColor, 0.4)
            radius: 10
                    
            AudioSliders {
                value: Audio.sourceVolume
                onMoved: Audio.setSourceVolume(value)
            }
        }
    }

    Rectangle {
        implicitWidth: 275
        implicitHeight: 140
        radius: 10
        color: root.mColor 
    }
}
