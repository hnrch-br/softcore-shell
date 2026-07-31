import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Layouts

import qs.bar
import qs.services

Scope {
    PanelWindow {
        id: root
        property color mColor: "#3a2b2a"
        property color sColor: "#faebd7"
        color: "transparent"

        mask: Region {
        	Region { item: topLeft }
            Region { item: topRight }
            Region { item: clock }
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
            implicitWidth: leftRow.implicitWidth + 38
            color: root.mColor
            bottomRightRadius: 10

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

        Clock { id: clock }

        Rectangle {
            id: topRight
            implicitHeight: 35
            implicitWidth: rightRow.width + 38
            color: root.mColor
            bottomLeftRadius: 10
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
            rotation: 90
        }
        Corner {
            id: rightBottomCorner
            anchors.right: topRight.right
            anchors.bottom: topRight.bottom
            anchors.bottomMargin: -radius
            rotation: 90
        }

        Corner { 
            id: leftCorner
            anchors.right: topLeft.right
            anchors.rightMargin: -radius
            anchors.top: topLeft.top
        }
        Corner {
            id: leftBottomCorner
            anchors.bottom: topLeft.bottom
            anchors.left: topLeft.left 
            anchors.bottomMargin: -radius
        } 

        component Corner: Shape {
        	id: corner
            preferredRendererType: Shape.CurveRenderer

            property real radius: 25

            ShapePath {
            	strokeWidth: 0
            	fillColor: root.mColor

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

        Scope {
    		PanelWindow {
        		anchors.left: true
        		implicitWidth: 0
        		implicitHeight: topLeft.implicitHeight
        	}
        }
        Scope {
        	PanelWindow {
        		anchors.top: true
        		implicitWidth: 0
        		implicitHeight: 35
        	}
        }
        Scope {
        	PanelWindow {
        		anchors.right: true
        		implicitWidth: 0
        		implicitHeight: topRight.implicitHeight
        	}
        }
    }
}

