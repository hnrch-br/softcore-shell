pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

import qs.services

Scope {
    id: root

    property bool isOpen: false
    readonly property color mColor: "#3a2b2b"
    readonly property color sColor: "#ccfaebd7"

    LazyLoader {
        loading: !root.isOpen
        PanelWindow {
            id: clipboard

            anchors {
                top: true
                bottom: true
                right: true
                left: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "clipboard"

            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: "transparent"

            IpcHandler {
                target: "clipboard"

                function toggleVisible(): void {
                    root.isOpen = !root.isOpen;
                }
            }

            visible: false

            Rectangle {
                id: clipWrapper

                color: root.mColor
                state: root.isOpen ? "opened" : "closed"

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom

                implicitWidth: 500
                implicitHeight: 260
                topLeftRadius: 25
                topRightRadius: 25

                Rectangle {
                    id: listRect

                    implicitWidth: parent.width - 16
                    implicitHeight: parent.height - 18

                    radius: 20

                    color: Qt.darker(root.mColor, 0.85)

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 10
                    }

                    ClipList {}
                }

                Corner {
                    id: leftCorner
                    x: -radius
                    anchors.bottom: parent.bottom
                    rotation: 180
                }

                Corner {
                    id: rightCorner
                    x: parent.width
                    anchors.bottom: parent.bottom
                    rotation: 270
                }

                states: [
                    State {
                        name: "opened"
                        PropertyChanges {
                            target: clipWrapper
                            implicitHeight: 260
                            opacity: 1
                        }
                    },
                    State {
                        name: "closed"
                        PropertyChanges {
                            target: clipWrapper
                            implicitHeight: 0
                            opacity: 0
                        }
                    }
                ]
                transitions: [
                    Transition {
                        from: "closed"
                        to: "opened"
                        SequentialAnimation {
                            PropertyAction {
                                target: clipboard
                                property: "visible"
                                value: true
                            }
                            ParallelAnimation {
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "implicitHeight"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "opacity"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }
                        }
                    },
                    Transition {
                        from: "opened"
                        to: "closed"
                        SequentialAnimation {
                            ParallelAnimation {
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "implicitHeight"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "opacity"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }
                            PropertyAction {
                                target: clipboard
                                property: "visible"
                                value: false
                            }
                        }
                    }
                ]
            }
        }
    }

    component Corner: Shape {
        id: corner
        preferredRendererType: Shape.CurveRenderer

        property real radius: 30

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
