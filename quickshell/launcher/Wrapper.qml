pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Shapes

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Overlay 
    WlrLayershell.namespace: "launcher"
    WlrLayershell.keyboardFocus: isOpen ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None

    exclusionMode: ExclusionMode.Ignore

    property bool isOpen: false

    visible: isOpen ? true : false

    IpcHandler {
        target: "launcher"

        function toggleAppVisible(): void {
            root.isOpen = !root.isOpen;
            if (root.isOpen) {
                searchField.forceActiveFocus()
                searchField.text = "" 
                searchField.forceActiveFocus()
                appResultList.currentIndex = 0
                appResultList.visible = true
            }
        }
    }

    property var funcs: SearchFunc {
        wrapper: root
    }

    property var filteredApps: funcs.computeFilteredApps(
        searchField.text,
        DesktopEntries.applications.values
    )

    property color mColor: "#473d3636"
    property color sColor: "#ccfaebd7"
    property color mTxtColor: "#ff3d3636"
    property color sTxtColor: "#ffcdcdcd" 

    anchors.bottom: true

    implicitWidth: 640
    implicitHeight: 300

    color: "transparent"

    WrapperRectangle {
        id: launcherRect

        implicitWidth: parent.width - 90
        implicitHeight: parent.height
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        topLeftRadius: 15
        topRightRadius: 15
        color: root.mColor

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 3
            Rectangle {
                id: searchBar
                
                implicitWidth: launcherRect.width - 20
                implicitHeight: 50
                
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 10
                radius: 10
                color: root.sColor

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignVCenter
                    anchors.verticalCenter: parent.verticalCenter
                    IconImage {
                        source: Quickshell.iconPath("edit-find")
                        implicitSize: 40
                        Layout.leftMargin: 5
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: Qt.alpha(root.mColor, 0.9)
                        }
                    }
                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        placeholderText: "..."
                        background: null
                        font { family: "Sixtyfour"; pixelSize: 15 }
                        color: Qt.alpha(root.mTxtColor, 0.8)

                        Keys.onDownPressed: appResultList.incrementCurrentIndex()
                        Keys.onUpPressed: appResultList.decrementCurrentIndex()
                        Keys.onReturnPressed: (event) => {
                            funcs.launchCurrent(filteredApps[appResultList.currentIndex])
                            event.accepted = true
                        }
                        Keys.onEscapePressed: root.isOpen = false

                        onTextChanged: appResultList.currentIndex = 0
                    }
                }
            }

            Rectangle {
                id: wrapperList
                Layout.fillHeight: true
                Layout.topMargin: 14
                Layout.bottomMargin: 9
                implicitWidth: launcherRect.implicitWidth - 20
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.sColor
                radius: 10

                ListView {
                    id: appResultList
                    anchors.fill: parent
                    anchors.margins: 5
                    currentIndex: 0
                    clip: true
                    spacing: 4

                    model: root.filteredApps

                    delegate: Rectangle {
                        required property var modelData
                        
                        implicitHeight: childrenRect.height
                        implicitWidth: parent.width

                        radius: 5

                        color: ListView.isCurrentItem ? Qt.tint(Qt.alpha(root.mColor, 0.9), "#cced752b") : "transparent"
                        
                        MouseArea {
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            anchors.fill: parent
                            onClicked: funcs.launchCurrent(modelData)
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter

                            IconImage {
                                source: Quickshell.iconPath(modelData.icon, "application-x-executable")
                                implicitSize: 32
                                Layout.leftMargin: 5
                                layer.enabled: true
                                layer.effect: MultiEffect {
                                    colorization: 1.0
                                    colorizationColor: Qt.alpha(root.mColor, 0.9)
                                }
                            }

                            Text {
                                text: modelData.name
                                color: root.mTxtColor
                                font { family: "Pixelify Sans"; pixelSize: 15 }
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }
                        }
                    }
                }
            }
        } 
    }
    
    Corner {
        x: 0
        anchors.bottom: parent.bottom
        rotation: 180
    }

    Corner {
        x: launcherRect.width + radius
        anchors.bottom: parent.bottom
        rotation: 270
    }

    component Corner: Shape {
		id: corner
		preferredRendererType: Shape.CurveRenderer

		property real radius: 45

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
}
