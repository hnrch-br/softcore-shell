import Quickshell
import QtQuick
import QtQuick.Shapes

import qs.popups

Item {
    anchors.horizontalCenter: parent.horizontalCenter
    implicitHeight: childrenRect.height
    implicitWidth: childrenRect.width
    Row {
        id: clockRow
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: calendarpopup.visible ? 0 : 1

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
            color: "#ccfaebd7"
    
            Text {
                anchors.centerIn: parent
                text: Qt.formatDateTime(clock.date, "HH:mm")
    	        color: "#ff3d3636"
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
        id: calendarpopup
        anchor.item: clockRect
        anchor.adjustment: PopupAdjustment.None
        anchor.edges: Edges.Top
        anchor.margins.left: -400
    }

    MouseArea {
        cursorShape: Qt.PointingHandCursor
        anchors.fill: parent
        onClicked: calendarpopup.isOpen = !calendarpopup.isOpen
    }

    component Corner: Shape {
        id: corner
		preferredRendererType: Shape.CurveRenderer

		property real radius: 30

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
