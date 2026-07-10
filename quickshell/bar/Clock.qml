pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes

import qs.popups
import qs.services

Item {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    implicitHeight: 48
    implicitWidth: childrenRect.width

    property color mColor: "#473d3636"
    property color sColor: "#ccfaebd7"
    property color mTxtColor: "#ff3d3636"

    Row {
        id: clockRow
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: calendarPopup.visible ? 0 : 1

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        Corner {
            id: leftCorner
            x: -radius
            rotation: 90
        } 

        Rectangle {
            id: clockRect
            implicitWidth: 140
            implicitHeight: 45
            bottomLeftRadius: 15
            bottomRightRadius: 15
            color: root.sColor 

            Behavior on implicitHeight {
                NumberAnimation { duration: 250 }
            } 

            Text {
                anchors.centerIn: parent
                text: Qt.formatDateTime(clock.date, "HH:mm")
    	        color: root.mTxtColor
            	font {family: "Ndot 57"; pixelSize: 35 }
                bottomPadding: 7
            }

            SystemClock {
            	id: clock
            	precision: SystemClock.Minutes
            }
        }
        Corner {
            id: rightCorner
            x: radius + clockRect.implicitWidth
        }
    }

    CalendarPopup{ 
        id: calendarPopup
        anchor {
            item: root
            adjustment: PopupAdjustment.None
            edges: Edges.Top
            margins.left: -calendarPopup.implicitWidth
            margins.top: 0
        }
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: calendarPopup.isOpen = !calendarPopup.isOpen
    }

    component Corner: Shape {
        id: corner
		preferredRendererType: Shape.CurveRenderer

		property real radius: 30

		ShapePath {
			strokeWidth: 0
			fillColor: root.sColor

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
