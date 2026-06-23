pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
import Quickshell.Io
import Qt5Compat.GraphicalEffects
import qs.bar.widgets

PopupWindow {
    id: root
    implicitHeight: 300
    implicitWidth: 400
    color: "transparent"
    
    property date currentDate: new Date()
    property date selectedDate: new Date()
    property int month: currentDate.getMonth()
    property int year: currentDate.getFullYear()

    HyprlandFocusGrab {
        active: root.isOpen
        windows: [root]
        onCleared: {
            closeAnim.start();
        }
    }

    property bool isOpen: false
    
    onIsOpenChanged: {
        if (!isOpen) {
            visible = false;
        }
        else {
            visible = true;
        }
    }
    
    Rectangle {
        id: calendarArea
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.visible ? parent.height : 0
        implicitWidth: parent.width - 50
        color: "#ccfaebd7"
        opacity: visible ? 1 : 0
        bottomLeftRadius: 15
        bottomRightRadius: 15

        Behavior on implicitHeight {
            NumberAnimation { duration: 250 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 250 }
        }
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.centerIn: parent
            
            DayOfWeekRow {
                locale: grid.locale
                Layout.column: 1
                Layout.fillWidth: true
                delegate: Text {
                    text: shortName
                    font.family: "Sixtyfour"
                    font.pixelSize: 7
                    color: "#ff5c4033"
                    horizontalAlignment: Text.AlignHCenter
                    leftPadding: 5

                    required property string shortName
                }
            }

            MonthGrid {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                month: root.month
                year: root.year
                locale: Qt.locale()

                delegate: Rectangle {
                    implicitWidth: 35
                    implicitHeight: 35

                    required property var model
                    property bool isCurrentMonth: model.month === root.month
                    property bool isToday: model.date.toDateString() === root.currentDate.toDateString()

                    color: isToday ? "#aa3d3636" : "transparent"
                    radius: height / 2
    
                    Text {
                        anchors.centerIn: parent
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: model.day
                        font.family: "Sixtyfour"
                        font.pixelSize: 8
                        color: parent.isToday ? "#ccfaebd7" : parent.isCurrentMonth ? "#ff5c4033" : Qt.darker("#823d3636", 0.9)
                        font.bold: parent.isToday
                    }
                }
            }
        }
        Corner {
            id: leftCorner
            x: -radius
            rotation: 90
        }

        Corner {
            id: rightCorner
            x: calendarArea.width
        }
    }

    SequentialAnimation {
        id: closeAnim
        ParallelAnimation {
            NumberAnimation {
                target: calendarArea
                property: "implicitHeight"
                to: 0
                duration: 250
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: calendarArea
                property: "opacity"
                to: 0
                duration: 250
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
			fillColor: "#ccfaebd7"
    
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
