pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Shapes

import qs.calendar
import qs.services

Item {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    implicitHeight: 48
    implicitWidth: clockRow.implicitWidth

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

        CornerLeft { anchors.top: parent.top} 

        Rectangle {
            id: clockRect
            implicitWidth: 115
            implicitHeight: 45 
            color: root.sColor 

            Behavior on implicitHeight {
                NumberAnimation { duration: 250 }
            } 

            Text {
                anchors.centerIn: parent
                text: Qt.formatDateTime(clock.date, "HH:mm")
    	        color: root.mTxtColor
            	font {family: "Ndot 55 Caps"; pixelSize: 40 }
                bottomPadding: 0
            }

            SystemClock {
            	id: clock
            	precision: SystemClock.Minutes
            }
        }

        CornerRight { anchors.top: parent.top }
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

    component CornerLeft: Shape {
        id: cornerL
		preferredRendererType: Shape.CurveRenderer

        property real radius: 30

		ShapePath {
			strokeWidth: 0
			fillColor: root.sColor

            startX: 0

            PathArc {
                relativeX: cornerL.radius
                relativeY: cornerL.radius
                radiusX: cornerL.radius
                radiusY: cornerL.radius
            }

            PathArc {
                relativeX: cornerL.radius / 2
                relativeY: cornerL.radius / 2
                radiusX: cornerL.radius / 2
                radiusY: cornerL.radius / 2
                direction: PathArc.Counterclockwise
            }

            PathLine {
                relativeX: 0
                relativeY: -(3 / 2) * cornerL.radius
            }
            PathLine {
                relativeY: 0
                relativeX: -(3 / 2) * cornerL.radius
            }
        }
    }
    component CornerRight: Shape {
        id: cornerR
        preferredRendererType: Shape.CurveRenderer

        property real radius: 30

        ShapePath {
            strokeWidth: 0
            fillColor: root.sColor

            startX: (3 / 2) * cornerR.radius
            PathArc {
                relativeX: -cornerR.radius
                relativeY: cornerR.radius
                radiusX: cornerR.radius
                radiusY: cornerR.radius
                direction: PathArc.Counterclockwise
            }
            PathArc {
                relativeX: -cornerR.radius / 2
                relativeY: cornerR.radius / 2
                radiusX: cornerR.radius / 2
                radiusY: cornerR.radius / 2
            }

            PathLine {
                relativeX: 0
                relativeY: -(3 / 2) * cornerR.radius
            }
            PathLine {
                relativeY: 0
                relativeX: (3 / 2) * cornerR.radius
            }
        }
    }
}
