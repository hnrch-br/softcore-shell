pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

import qs.services
import qs.central.components

Scope {
    id: root

    property bool isOpen: false
    readonly property color mColor: "#3a2b2b"
    readonly property color sColor: "#ccfaebd7"
    property string activeView: "main"

    LazyLoader {
        loading: !root.isOpen
        PanelWindow {
            id: centralPopup

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "centralPopup"
            exclusionMode: ExclusionMode.Ignore

            mask: Region {
                item: centralWrapper
            }

            HyprlandFocusGrab {
                active: root.isOpen
                windows: [centralPopup]
                onCleared: root.isOpen = false
            }

            IpcHandler {
                target: "centralPopup"

                function toggleVisible(): void {
                    root.isOpen = !root.isOpen;
                    root.activeView = "main";
                }
            }

            Shortcut {
                sequence: "Escape"
                onActivated: root.isOpen = false
            }

            visible: false
            color: "transparent"

            anchors {
                top: true
                right: true
            }

            margins.top: 35

            implicitWidth: 325
            implicitHeight: 500

            Rectangle {
                id: centralWrapper

                anchors.right: parent.right
                implicitWidth: 300
                implicitHeight: 475

                color: root.mColor
                state: root.isOpen ? "opened" : "closed"

                topLeftRadius: 0
                bottomLeftRadius: 10
                bottomRightRadius: 0

                clip: true

                MainPanel {
                    id: mainPanel
                    visible: root.activeView === "main"
                }

                NetList {
                    id: netList
                    visible: root.activeView === "net"
                }

                BtList {
                    id: btList
                    visible: root.activeView === "bt"
                }

                states: [
                    State {
                        name: "opened"
                        PropertyChanges {
                            target: centralWrapper
                            implicitWidth: 300
                            implicitHeight: 475
                            opacity: 1
                        }
                    },
                    State {
                        name: "closed"
                        PropertyChanges {
                            target: centralWrapper
                            implicitHeight: 0
                            implicitWidth: 0
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
                                target: centralPopup
                                property: "visible"
                                value: true
                            }
                            ParallelAnimation {
                                NumberAnimation {
                                    target: centralWrapper
                                    property: "implicitHeight"
                                    duration: 100
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: centralWrapper
                                    property: "implicitWidth"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: centralWrapper
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
                                    target: centralWrapper
                                    property: "implicitHeight"
                                    duration: 100
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: centralWrapper
                                    property: "implicitWidth"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: centralWrapper
                                    property: "opacity"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }
                            PropertyAction {
                                target: centralPopup
                                property: "visible"
                                value: false
                            }
                        }
                    }
                ]
            }

            Corner {
                id: cornerLeftTop
                anchors.top: centralWrapper.top
                anchors.left: centralWrapper.left
                anchors.leftMargin: -radius
                rotation: 90
            }

            Corner {
                id: cornerRightBottom
                anchors.bottom: centralWrapper.bottom
                anchors.right: centralWrapper.right
                anchors.bottomMargin: -radius
                rotation: 90
            }

            IpcHandler {
                target: "netList"

                function toggleVisible(): void {
                    root.activeView = "net";
                }

                function goBack(): void {
                    root.activeView = "main";
                }
            }

            IpcHandler {
                target: "btList"

                function toggleVisible(): void {
                    root.activeView = "bt";
                }

                function goBack(): void {
                    root.activeView = "main";
                }
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
}
