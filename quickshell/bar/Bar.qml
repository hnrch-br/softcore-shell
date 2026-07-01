import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Pipewire
import QtQuick.Controls
import Quickshell.Io
import QtQuick.Effects

import qs.bar
import qs.popups
import qs.services

Scope {
	PanelWindow {
		id: root
		property color mColor: "#823d3636"
		property color sColor: "#ccfaebd7"

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
			implicitWidth: leftRow.implicitWidth + 25
			color: root.mColor
            bottomRightRadius: 15
			anchors {
				top: parent.top
				left: parent.left
			}
			Corner { 
				id: leftCorner
				x: topLeft.implicitWidth 
				y: 0
			}
			Corner {
				id: leftTopCorner
				x: 0
				y: 35
			}

			Row {
                id: leftRow
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                Workspaces {}
                MediaPlayer {}
                Cava {}
			}
		}

        Clock { id: clock }

        Rectangle {
			id: topRight
			implicitHeight: 35
			implicitWidth: rightRow.width + 25
            color: root.mColor
			bottomLeftRadius: 15
			anchors {
				top: parent.top
				right: parent.right
			}
			Corner {
				id: rightCorner
				x: -radius
				rotation: 90
			}
			Corner {
				id: rightTopCorner
				x: topRight.implicitWidth - radius
				y: 35
				rotation: 90
			}

			Row {
                id: rightRow
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.verticalCenter: parent.verticalCenter
                spacing: 2
                WtWidget {}
                AudioStatus {}
                SysStats {}
			}
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

