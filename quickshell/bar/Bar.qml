import Quickshell
import QtQuick
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import Quickshell.Services.Pipewire
import QtQuick.Controls
import "./widgets"


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
			implicitWidth: (QsWindow.window.width / 2) - 350
			color: root.mColor
			bottomRightRadius: 15
			anchors {
				top: parent.top
				left: parent.left
			}
			RowLayout {
				anchors.fill: parent
				anchors.leftMargin: 20
				anchors.topMargin: 5

				RowLayout {
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
			implicitWidth: ( QsWindow.window.width / 2 )
			color: "transparent"
			anchors {
				top: parent.top
				horizontalCenter: parent.horizontalCenter
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
					implicitWidth: 150
					implicitHeight: 50
					bottomRightRadius: 25
					bottomLeftRadius: 25
					color: root.sColor
					Clock { 
						anchors {
							horizontalCenter: parent.horizontalCenter
							verticalCenter: parent.verticalCenter
						}
					}
				}
			}
		}

		Rectangle {
			id: topRight
			implicitHeight: 35
			implicitWidth: ( QsWindow.window.width / 2 ) - 350
			color: root.mColor
			bottomLeftRadius: 15
			anchors {
				top: parent.top
				right: parent.right
			}
			RowLayout {
				anchors.fill: parent
				anchors.rightMargin: 20
				anchors.topMargin: 7
				anchors.bottomMargin: 8
				RowLayout {
					anchors {
						right: parent.right
						verticalCenter: parent.verticalCenter
					}
					Weather {}
					AudioControl {}
					SysStats {}
				}	
			}
		}

		Corner2 {
			id: clockLeftTopCorner
			x: ( QsWindow.window.width / 2 ) - ( radius + ( clockSpace.implicitWidth / 2 ) )
			y: 0
			rotation: 90
		}

		Corner2 {
			id: clockRightTopCorner
			x: clockLeftTopCorner.x + radius + clockSpace.implicitWidth
			y: 0
		}
		
		// Left Corner
		Corner { 
			id: leftCorner
			x: ( QsWindow.window.width / 2 ) - 350
			y: 0
		}
		
		Corner {
			id: rightCorner
			x: QsWindow.window.width - 635
			rotation: 90
		}

		// Top Left Corner
		Corner {
			id: leftTopCorner
			x: 0
			y: 35
		}

		// Top Right Corner
		Corner {
			id: rightTopCorner
			x: QsWindow.window.width - radius
			y: 35
			rotation: 90
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

