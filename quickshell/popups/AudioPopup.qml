pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Hyprland
import QtQuick.Shapes
import QtQuick.Layouts
import QtQuick.Controls

import qs.bar
import qs.services

PopupWindow {
    id: root
    implicitHeight: 290
    implicitWidth: 200
    color: "transparent"

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

    Rectangle {
        id: audioPopupOuter
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        implicitHeight: root.visible ? parent.height : 0
        implicitWidth: root.visible ? parent.width - 40 : 0
        opacity: root.visible ? 1 : 0
        color: "#823d3636"
        bottomLeftRadius: 10
        bottomRightRadius: 10

        Behavior on opacity {
            NumberAnimation { duration: 100 }
        }

        Behavior on implicitHeight {
            NumberAnimation { duration: 100 }
        }

        Behavior on implicitWidth {
            NumberAnimation { duration: 100 }
        }

        Rectangle {
            id: audioPopupInner
            opacity: root.visible ? 1 : 0
            color: "#ccfaebd7" 
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            implicitHeight: root.visible ? 280 : 0
            implicitWidth: root.visible ? 140 : 0
            radius: 5

            RowLayout {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                Slider {
                    id: volControl
                    orientation: Qt.Vertical
                    from: 0.0
                    to: 1.0
                    snapMode: Slider.SnapAlways
                    stepSize: 0.05
                    value: Audio.defaultSink?.audio.volume ?? 0
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    onMoved: {
                        if (Audio.defaultSink?.ready)
                            Audio.defaultSink.audio.volume = value
                    }
                    handle: Rectangle {
                        id: volHandler  
                        implicitWidth: 30
                        implicitHeight: 10 
                        radius: 5
                        color: "#ff353535"
                        x: volControl.leftPadding + volControl.availableWidth / 2 - width / 2
                        y: volControl.topPadding + volControl.visualPosition * (volControl.availableHeight - height)
                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    background: Rectangle {
                        id: volBack
                        anchors {
                        horizontalCenter: parent.horizontalCenter
                        } 
                        implicitHeight: 200
                        implicitWidth: 4
                        width: implicitWidth
                        radius: 5
                        color: "#b33d3636"
                    }
                    Layout.rightMargin: 10
                }
    
                Slider {
                    id: micControl
                    orientation: Qt.Vertical
                    anchors {
                        top: parent.top
                        bottom: parent.bottom
                    }
                    from: 0.0
                    to: 1.0
                    snapMode: Slider.SnapAlways
                    stepSize: 0.05
                    value: Audio.defaultSource?.audio.volume ?? 0
                    onMoved: {
                        if (Audio.defaultSource?.ready)
                            Audio.defaultSource.audio.volume = value
                    }
                    handle: Rectangle {
                        implicitWidth: 30
                        implicitHeight: 10
                        radius: 5
                        color: "#ff353535"
                        x: micControl.leftPadding + micControl.availableWidth / 2 - width / 2
                        y: micControl.topPadding + micControl.visualPosition * (micControl.availableHeight - height)
                        HoverHandler {
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                    background: Rectangle {
                        anchors {
                            horizontalCenter: parent.horizontalCenter
                        }
                        implicitHeight: 200
                        implicitWidth: 4
                        width: implicitWidth
                        radius: 5
                        color: "#b33d3636"
                    }
                    Layout.leftMargin: 10
                }
            }
    
            Behavior on opacity {
                NumberAnimation { duration: 100 }
            }
    
            Behavior on implicitHeight {
                NumberAnimation { duration: 100 }
            }

            Behavior on implicitWidth {
                NumberAnimation { duration: 150 }
            }
        }

        Corner {
            id: leftCorner
            x: -radius
            rotation: 90
        }

        Corner {
            id: rightCorner
            x: audioPopupOuter.width
        }

        component Corner: Shape {
            id: corner
		    preferredRendererType: Shape.CurveRenderer

		    property real radius: 20

	    	ShapePath {
    			strokeWidth: 0
    			fillColor: "#823d3636"

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
    
    SequentialAnimation {
        id: closeAnim
        ParallelAnimation {
            NumberAnimation {
                target: audioPopupOuter
                property: "implicitHeight"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: audioPopupInner
                property: "implicitHeight"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: audioPopupOuter
                property: "opacity"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: audioPopupInner
                property: "opacity"
                to: 0
                duration: 100
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: audioPopupOuter
                property: "implicitWidth"
                duration: 100
                to: 0
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                target: audioPopupInner
                property: "implicitWidth"
                duration: 100
                to: 0
                easing.type: Easing.OutQuad
            }
        }
        ScriptAction {
            script: {
                root.isOpen = false;
            }
        }
    }
}
