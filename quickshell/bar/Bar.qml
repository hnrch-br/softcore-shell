import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts

import qs.clockisland
import qs.services

Scope {
    PanelWindow {
        id: root
        readonly property color mColor: "#3a2b2a"
        readonly property color sColor: "#faebd7"
        
        color: "transparent"

        mask: Region {
        	Region { item: topLeft }
            Region { item: topRight }
        }

        anchors {
        	left: true
        	top: true
            right: true 
        }

        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            id: topLeft
            implicitHeight: 35
            implicitWidth: leftRow.implicitWidth + 37
            color: root.mColor
            bottomRightRadius: 17.5

            anchors {
            	top: parent.top
            	left: parent.left
            } 

            RowLayout {
                id: leftRow
                spacing: 5
                anchors.left: parent.left
                anchors.leftMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                Workspaces {}
                RowLayout {
                    spacing: 2
                    Layout.alignment: Qt.AlignVCenter
                    MediaPlayer {}
                    Cava {}
                }
            }
        }

        ClockIsland { id: clockisland }

        Rectangle {
            id: topRight
            implicitHeight: 35
            implicitWidth: rightRow.width + 37
            color: root.mColor
            bottomLeftRadius: 17.5
            anchors {
            	top: parent.top
            	right: parent.right
            }
            
            RowLayout {
                id: rightRow
                anchors.right: parent.right
                anchors.rightMargin: 30
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                WtWidget {}
                SysStats {}
                CentralButton {}
            }
            Behavior on implicitWidth {
                NumberAnimation { duration: 100 }
            }
        }
        
        Corner {
            id: rightCorner
            anchors.left: topRight.left
            anchors.leftMargin: -radius
            anchors.top: topRight.top
            radius: 17.5
            mirror: false
        }
        Corner {
            id: rightBottomCorner
            anchors.right: topRight.right
            anchors.bottom: topRight.bottom
            anchors.bottomMargin: -radius
            radius: 25
            mirror: false
        }
        Corner { 
            id: leftCorner
            anchors.right: topLeft.right
            anchors.rightMargin: -radius
            anchors.top: topLeft.top
            radius: 17.5
            mirror: true
        }
        Corner {
            id: leftBottomCorner
            anchors.bottom: topLeft.bottom
            anchors.left: topLeft.left 
            anchors.bottomMargin: -radius
            radius: 25
            mirror: true
        } 

        component Corner: Shape {
        	id: corner
            preferredRendererType: Shape.CurveRenderer
            
            property bool mirror: false
            property real radius: 0

            ShapePath {
            	strokeWidth: 0
            	fillColor: root.mColor

            	startX: mirror ? corner.radius : 0

            	PathArc {
                    relativeX: mirror ? -corner.radius : corner.radius
                    relativeY: corner.radius
                    radiusX: corner.radius
                    radiusY: corner.radius
                    direction: mirror ? PathArc.Counterclockwise : PathArc.Clockwise
                }

                PathLine {
                	relativeX: 0
                	relativeY: -corner.radius
                }

                PathLine {
                    relativeX: mirror ? corner.radius : 0
                	relativeY: 0
                }
            }
        }

        Scope {
        	PanelWindow {
        		anchors.top: true
        		implicitWidth: 0
                implicitHeight: 35
                color: "transparent"
        	}
        } 
    }
}

