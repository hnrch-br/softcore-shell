import QtQuick
import Quickshell

import qs.services

Item {
    id: clock
    implicitWidth: clock.horizontal ? 145 : 45
    implicitHeight: clock.horizontal ? 45 : 145
    property bool horizontal: true

    Text {
        opacity: clock.horizontal && !root.isExpanded
        anchors.centerIn: parent
        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
        text: Time.format("HH mm")
        color: root.sColor
        font {
            family: "Ndot 55"
            pixelSize: 35
        }
    }
    Text {
        opacity: !clock.horizontal && root.isExpanded
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
        text: Time.format("HH\nmm")
        color: root.sColor
        font {
            family: "Ndot 55"
            pixelSize: 42
        }
    }
}
