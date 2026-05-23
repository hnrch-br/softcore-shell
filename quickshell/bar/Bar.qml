import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Pipewire
import QtQuick.Controls
import "./widgets"
import "./widgets/trays"

Scope {
	PanelWindow {
		id: root
		property color mColor: "#823d3636"
		property color sColor: "#ccfaebd7"

		color: "transparent"
		exclusionMode: ExclusionMode.Ignore
		mask: Region {
			Region { item: topLeft }
			Region { item: topRight }
			Region { item: topMiddle }
		}

		anchors {
			left: true
			top: true
			right: true
		}
		
		Rectangle {
			id: topLeft
			implicitHeight: 35
			implicitWidth: wsRow.implicitWidth + 30
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

			RowLayout {
				anchors.fill: parent
				anchors.leftMargin: 20
				anchors.topMargin: 5

				RowLayout {
					id: wsRow
					anchors {
						left: parent.left
						top: parent.top
					}
					Workspaces {}
				}
			}
		}

		Rectangle {
			id: topMiddle
			implicitHeight: 35
			implicitWidth: clockSpace.implicitWidth
			color: "transparent"
			anchors {
				top: parent.top
				horizontalCenter: parent.horizontalCenter
			}

			Corner2 {
				id: clockLeftTopCorner
				x: -radius
				y: 0
				rotation: 90
			}

			Corner2 {
				id: clockRightTopCorner
				x: clockSpace.implicitWidth
				y: 0
			}
		

			RowLayout {
				anchors.topMargin: 5
				anchors.fill: parent
				anchors.horizontalCenter: parent.horizontalCenter
				anchors.verticalCenter: parent.verticalCenter
				Rectangle {
					id: clockSpace
					anchors {
						horizontalCenter: parent.horizontalCenter
						verticalCenter: parent.verticalCenter
					}	
					implicitWidth: clockItem.implicitWidth + 80
					implicitHeight: 50
					bottomRightRadius: 25
					bottomLeftRadius: 25
					color: root.sColor
					Clock { 
						id: clockItem
						anchors {
							horizontalCenter: parent.horizontalCenter
							verticalCenter: parent.verticalCenter
						}
						topPadding: 4
					}
				}
			}
		}

		Rectangle {
			id: topRight
			implicitHeight: 35
			implicitWidth: widgetsRow.implicitWidth + 36
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

			RowLayout {
				anchors.fill: parent
				anchors.rightMargin: 20
				anchors.topMargin: 7
				anchors.bottomMargin: 8
				RowLayout {
					id: widgetsRow
					anchors {
						right: parent.right
						verticalCenter: parent.verticalCenter
					}
					MediaPlayer {}
					Weather {}
					AudioControl {}
					SysStats {}
				}	
			}
		}
		
		component Corner2: Shape {
			id: corner2
			preferredRendererType: Shape.CurveRenderer

			property real radius: 25

			ShapePath {
				strokeWidth: 0
				fillColor: root.sColor

				startX: corner2.radius
				
				PathArc {
					relativeX: -corner2.radius
					relativeY: corner2.radius
					radiusX: corner2.radius
					radiusY: corner2.radius
					direction: PathArc.Counterclockwise
				}

				PathLine {
					relativeX: 0
					relativeY: -corner2.radius
				}

				PathLine {
					relativeX: corner2.radius
					relativeY: 0
				}
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
				implicitHeight: topMiddle.implicitHeight
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

