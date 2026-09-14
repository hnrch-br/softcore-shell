pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
import QtQuick.Effects

import qs.bar
import qs.services

Scope {
    LazyLoader {
        loading: true
        PanelWindow {
            id: root
            implicitHeight: 300
            implicitWidth: 400
            color: "transparent"

            property date currentDate: Time.date
            property date selectedDate: Time.date
            property int month: Time.months
            property int year: Time.years
            readonly property var locale: Qt.locale()

            readonly property color mColor: "#d6c5b2"
            readonly property color sColor: "#3a2b2a"
            readonly property color mTxtColor: "#ff3d3636"
            readonly property color sTxtColor: "#ffcdcdcd"

            anchors.top: true

            margins.top: 0

            WlrLayershell.layer: WlrLayer.Top
            WlrLayershell.namespace: "clock"
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
            exclusionMode: ExclusionMode.Ignore

            property bool isHovered: hover.hovered
            property bool isExpanded: false

            function resetDate() {
                currentDate = new Date();
                selectedDate = currentDate;
                month = currentDate.getMonth();
                year = currentDate.getFullYear();
            }

            onIsHoveredChanged: {
                if (isHovered) { 
                    root.isExpanded = true;
                    closeTimer.stop();
                } else {
                    closeTimer.restart();
                }
            }

            onIsExpandedChanged: resetDate()

            Timer {
                id: closeTimer
                interval: 150
                onTriggered: isExpanded = false
            }

            mask: Region {
                item: clockWrapper
            }

            exclusiveZone: 35

            Rectangle {
                id: clockWrapper
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                color: root.mColor
                bottomLeftRadius: 17.5
                bottomRightRadius: 17.5
                clip: true

                state: root.isExpanded ? "expanded" : "closed"

                HoverHandler {
                    id: hover
                }

                Clock {
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                    }
                    horizontal: true
                }

                RowLayout {
                    opacity: root.isExpanded

                    spacing: 20

                    clip: true

                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 12

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }

                    Clock {
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft
                        horizontal: false
                    }

                    ColumnLayout { 
                        spacing: 5

                        DateRow {}
                        CalendarGrid {}
                    }
                }

                states: [
                    State {
                        name: "expanded"
                        PropertyChanges {
                            target: clockWrapper
                            implicitWidth: 340
                            implicitHeight: 277
                            opacity: 1
                        }
                    },
                    State {
                        name: "closed"
                        PropertyChanges {
                            target: clockWrapper
                            implicitWidth: 130
                            implicitHeight: 35
                        }
                    }
                ]

                transitions: [
                    Transition {
                        from: "closed"
                        to: "expanded"
                        SequentialAnimation {
                            ParallelAnimation {
                                NumberAnimation {
                                    target: clockWrapper
                                    property: "implicitHeight"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: clockWrapper
                                    property: "implicitWidth"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                } 
                            }
                        }
                    },
                    Transition {
                        from: "expanded"
                        to: "closed"
                        SequentialAnimation {                
                            ParallelAnimation {
                                NumberAnimation {
                                    target: clockWrapper
                                    property: "implicitHeight"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: clockWrapper
                                    property: "implicitWidth"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                            } 
                        }
                    }
                ]
            }

            Shadow {}

            Corner {
                id: leftCorner
                anchors.left: clockWrapper.left
                anchors.leftMargin: -radius
                rotation: 90
            }   

            Corner {
                id: rightCorner
                anchors.right: clockWrapper.right
                anchors.rightMargin: -radius
            }

            component Corner: Shape {
                id: corner
                preferredRendererType: Shape.CurveRenderer

                property real radius: 17.5

                ShapePath {
                    strokeWidth: 0
                    fillColor: Qt.tint(Qt.alpha(root.mColor, 1.0), "#d6c5b2")

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

            component Shadow: RectangularShadow {
                z: -1
                anchors.fill: clockWrapper
                color: "black"
                spread: root.isExpanded ? 0.5 : 6
                radius: 5
                blur: root.isExpanded ? 20 : 50
                offset.x: 0
                offset.y: -5
            }
        }
    }
}
