pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
import Quickshell.Io

import qs.bar.widgets

PopupWindow {
    id: root
    implicitHeight: 300
    implicitWidth: 400
    color: "transparent"

    anchor {
        item: parent
        adjustment: PopupAdjustment.None
        edges: Edges.Top
        margins.left: -400
    }

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

    visible: root.isOpen ? true : false

    Rectangle {
        id: calendarArea
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.visible ? parent.height : 0
        implicitWidth: root.visible ? parent.width - 50 : 80
        color: "#ccfaebd7"
        opacity: visible ? 1 : 0
        bottomLeftRadius: 15
        bottomRightRadius: 15

        Behavior on implicitHeight {
            NumberAnimation { duration: 100 }
        }

        Behavior on implicitWidth {
            NumberAnimation { duration: 100 }
        }

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }
        ColumnLayout { 
            Layout.fillWidth: true
            Layout.fillHeight: true
            anchors.horizontalCenter: parent.horizontalCenter

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                spacing: 5
                Button {
                    id: lastMonth  
                    contentItem: Text {
                        text: "arrow_back_ios_new"
                        font { family: "Material Symbols Outlined"; pointSize: 9 }
                        color: lastMonth.down 
                            ? "#ccaaaaaa" 
                            : "#ff3d3636"
                        horizontalAlignment: Text.AlignHCenter
                        topPadding: 1
                    }

                    background: Rectangle {
                        id: leftBtnRect
                        implicitHeight: 20
                        implicitWidth: 25
                        bottomLeftRadius: 8
                        topLeftRadius: 8
                        bottomRightRadius: 2
                        topRightRadius: 2
                        color: lastMonth.down
                            ? "#823d3636"
                            : "#ccfaebd7"
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        root.month--;
                        grid.month = root.month;
                        grid.year = root.year;
                        if (root.month < 0) {
                            root.month = 11;
                            root.year--;
                        }
                    }
                }

                Text {
                    id: monthId
                    text: (new Date(root.year, root.month, 1)).toLocaleDateString(Qt.locale(), "MMMM, yyyy")
                    font { family: "Pixelify Sans"; pixelSize: 15 }
                    color: "#ff3d3636"
                    Layout.preferredWidth: 120
                    horizontalAlignment: Text.AlignHCenter
                }
                
                Button {
                    id: nextMonth
                    contentItem: Text {
                        text: "arrow_forward_ios"
                        font { family: "Material Symbols Outlined"; pointSize: 9 }
                        color: nextMonth.down
                            ? "#ffaaaaaa" 
                            : "#ff3d3636"
                        horizontalAlignment: Text.AlignHCenter
                        topPadding: 1
                    }

                    background: Rectangle {
                        id: rightBtnRect
                        implicitHeight: 20
                        implicitWidth: 25
                        bottomLeftRadius: 2
                        topLeftRadius: 2
                        bottomRightRadius: 8
                        topRightRadius: 8
                        color: nextMonth.down
                            ? "#823d3636"
                            : "#ccfaebd7"
                        anchors.centerIn: parent
                    }
                    onClicked: {
                        root.month++;
                        grid.month = root.month;
                        grid.year = root.year;
                        if (root.month > 11) {
                            root.month = 0;
                            root.year++;
                        }
                    }
                }

            }

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
                    id: gridRect
                    implicitWidth: 30
                    implicitHeight: 30

                    required property var model
                    property bool isCurrentMonth: model.month === root.month
                    property bool isToday: model.date.toDateString() === root.currentDate.toDateString()

                    color: isToday && isCurrentMonth ? "#aa3d3636" : isToday ? "#383d3636" : "transparent"
                    radius: implicitHeight / 2

                    Text {
                        id: monthDays
                        anchors.centerIn: gridRect
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: model.day
                        font.family: "Bytesized"
                        opacity: root.visible ? 1 : 0
                        font.pixelSize: 16
                        color: parent.isToday ? "#ccfaebd7" : parent.isCurrentMonth ? "#ff5c4033" : Qt.darker("#823d3636", 0.9)
                        font.bold: parent.isToday

                        Behavior on opacity {
                            NumberAnimation { duration: 250 }
                        }
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
