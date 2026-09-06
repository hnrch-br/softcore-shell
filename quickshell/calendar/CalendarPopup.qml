pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

import qs.bar
import qs.services

PopupWindow {
    id: root
    implicitHeight: 300
    implicitWidth: 400
    color: "transparent"

    property date currentDate: Time.date
    property date selectedDate: Time.date
    property int month: Time.months
    property int year: Time.years
    readonly property var locale: Qt.locale()

    readonly property color mColor: "#faebd7"
    readonly property color sColor: "#3a2b2a"
    readonly property color mTxtColor: "#ff3d3636"
    readonly property color sTxtColor: "#ffcdcdcd"

    HyprlandFocusGrab {
        active: root.isOpen
        windows: [root]
        onCleared: {
            closeAnim.start();
        }
    }

    Shortcut {
        sequence: "Escape"
        enabled: root.isOpen
        onActivated: closeAnim.start()
    }

    property bool isOpen: false
    visible: root.isOpen

    function resetDate() {
        currentDate = new Date();
        selectedDate = currentDate;
        month = currentDate.getMonth();
        year = currentDate.getFullYear();
    }

    onIsOpenChanged: {
        if (isOpen) return resetDate();
    }

    mask: Region {
        item: calendarArea
    }

    Rectangle {
        id: calendarArea
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.visible ? parent.height : 0
        implicitWidth: root.visible ? parent.width - 50 : 80
        color: Qt.tint(Qt.alpha(root.mColor, 1.0), "#d6c5b2")
        opacity: visible ? 1 : 0
        bottomLeftRadius: 15
        bottomRightRadius: 15

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 100
            }
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 100
            }
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter

            DateRow {}

            WeekRow {}

            CalendarGrid {}
        }

        Corner {
            id: leftCorner
            anchors.left: calendarArea.left
            anchors.leftMargin: -radius
            rotation: 90
        }
        Corner {
            id: rightCorner
            anchors.right: calendarArea.right
            anchors.rightMargin: -radius
        }
    }

    SequentialAnimation {
        id: closeAnim
        ParallelAnimation {
            NumberAnimation {
                target: calendarArea
                property: "implicitHeight"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: calendarArea
                property: "implicitWidth"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: calendarArea
                property: "opacity"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            } 
        }
        ScriptAction {
            script: {
                root.isOpen = false;
            }
        }
    }

    component Corner: Shape {
        id: corner
        preferredRendererType: Shape.CurveRenderer

        property real radius: 25

        ShapePath {
            strokeWidth: 0
            fillColor: Qt.tint(Qt.alpha(root.mColor, 1.0), "#d6c5b2")

            startX: corner.radius

            PathArc {
                relativeX: -corner.radius
                relativeY: corner.radius
                radiusX: corner.radius
                radiusY: corner.radius
                direction: PathArc.Counterclockwise
            }

            PathLine {
                relativeX: 0
                relativeY: -corner.radius
            }
            PathLine {
                relativeX: corner.radius
                relativeY: 0
            }
        }
    }
}
