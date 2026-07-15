pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

import qs.bar

PopupWindow {
    id: root
    implicitHeight: 300
    implicitWidth: 400
    color: "transparent"

    property date currentDate: new Date()
    property date selectedDate: new Date()
    property int month: currentDate.getMonth()
    property int year: currentDate.getFullYear()

    property color mColor: "#ccfaebd7"
    property color sColor: "#823d3636"
    property color mTxtColor: "#ff3d3636"
    property color sTxtColor: "#ffcdcdcd"

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
        onActivated: closeAnim.start();
    }

    property bool isOpen: false
    visible: root.isOpen ? true : false

    function resetDate() {
        currentDate = new Date();
        selectedDate = currentDate;
        month = currentDate.getMonth();
        year = currentDate.getFullYear();
    }

    onIsOpenChanged: {
        if (isOpen) resetDate();
    }

    Rectangle {
        id: calendarArea
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.visible ? parent.height : 0
        implicitWidth: root.visible ? parent.width - 50 : 80
        color: root.mColor
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
                        opacity: 1
                        color: lastMonth.down 
                            ? root.sTxtColor
                            : root.mTxtColor
                        horizontalAlignment: Text.AlignHCenter
                        topPadding: 1

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    background: Rectangle {
                        id: leftBtnRect
                        implicitHeight: 20
                        implicitWidth: 25
                        bottomLeftRadius: 8
                        topLeftRadius: 8
                        bottomRightRadius: 2
                        topRightRadius: 2
                        opacity: root.visible ? 1 : 0
                        color: lastMonth.down
                            ? Qt.tint(Qt.alpha(root.mColor, 1.0), "#cced752b")
                            : root.mColor
                        anchors.centerIn: parent
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    onClicked: {
                        root.month--;
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
                    color: root.mTxtColor
                    opacity: 1
                    Layout.preferredWidth: 120
                    horizontalAlignment: Text.AlignHCenter

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }
                }
                
                Button {
                    id: nextMonth
                    contentItem: Text {
                        text: "arrow_forward_ios"
                        font { family: "Material Symbols Outlined"; pointSize: 9 }
                        opacity: root.visible ? 1 : 0
                        color: nextMonth.down
                            ? root.sTxtColor 
                            : root.mTxtColor
                        horizontalAlignment: Text.AlignHCenter
                        topPadding: 1

                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    background: Rectangle {
                        id: rightBtnRect
                        implicitHeight: 20
                        implicitWidth: 25
                        bottomLeftRadius: 2
                        topLeftRadius: 2
                        bottomRightRadius: 8
                        topRightRadius: 8
                        opacity: root.visible ? 1 : 0
                        color: nextMonth.down
                            ? Qt.tint(Qt.alpha(root.mColor, 1.0), "#cced752b")
                            : root.mColor
                        anchors.centerIn: parent
                        
                        Behavior on opacity {
                            NumberAnimation { duration: 200 }
                        }
                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    onClicked: {
                        root.month++;
                        if (root.month > 11) {
                            root.month = 0;
                            root.year++;
                        }
                    }
                }

            }

            DayOfWeekRow {
                id: row
                locale: grid.locale
                Layout.column: 1
                Layout.fillWidth: true
                leftPadding: 2.1
                opacity: root.visible ? 1 : 0
                delegate: Text {
                    text: shortName
                    font.family: "Sixtyfour"
                    font.pixelSize: 7
                    color: Qt.tint(root.sColor, "#54ed752b")
                    horizontalAlignment: Text.AlignHCenter

                    required property string shortName
                }

                Behavior on opacity {
                    NumberAnimation { duration: 100 }
                }
            }

            MonthGrid {
                id: grid
                Layout.fillWidth: true
                Layout.fillHeight: true
                month: root.month
                year: root.year
                locale: Qt.locale()
                opacity: root.visible ? 1 : 0
                
                delegate: Rectangle {
                    id: gridRect
                    implicitWidth: 30
                    implicitHeight: 30

                    required property var model
                    property bool isCurrentMonth: model.month === root.month
                    property bool isToday: model.date.toDateString() === root.currentDate.toDateString()
                    property bool isSelected: model.date.toDateString() === root.selectedDate.toDateString()

                    color: isSelected 
                        ? Qt.tint(root.sColor, "#cced752b")
                        : isToday
                        ? Qt.alpha(root.sColor, 0.4)
                        : "transparent"
                    radius: implicitHeight / 2
                    
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        hoverEnabled: true
                        onClicked: root.selectedDate = gridRect.model.date
                    }

                    Text {
                        id: monthDays
                        anchors.centerIn: gridRect
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        text: gridRect.model.day
                        font.family: "Bytesized"
                        opacity: root.visible ? 1 : 0
                        font.pixelSize: 16
                        color: gridRect.isSelected
                            ? Qt.darker(root.sTxtColor, 0.9)
                            : gridRect.isToday
                            ? root.sTxtColor
                            : gridRect.isCurrentMonth
                            ? Qt.darker(root.mTxtColor, 0.65)
                            : Qt.darker(root.mTxtColor, 0.4)
                        font.bold: parent.isToday ? true : false
                        leftPadding: 3.1

                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                    }
                }

                Behavior on opacity {
                    NumberAnimation { duration: 200 }
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
            NumberAnimation {
                target: grid
                property: "opacity"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: row
                property: "opacity"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: leftBtnRect
                property: "opacity"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: rightBtnRect
                property: "opacity"
                duration: 200
                to: 0
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: monthId
                property: "opacity"
                duration: 200
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
