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
    property int selectedIndex: 0

    readonly property color mColor: "#3a2b2b"
    readonly property color sColor: "#ccfaebd7"

    property var entries: results(Clip.list, query)
    property string query: ""

    function results(list, q): void {
        if (q.length === 0) {
            list;
        }
        const f = q.toLowerCase();
        return list.filter(entry => entry.content && entry.content.toLowerCase().includes(f));
    }

    function moveSelection(delta) {
        if (root.entries.length === 0)
            return;
        var n = root.selectedIndex + delta;
        if (n < 0)
            n = 0;
        if (n > root.entries.length - 1)
            n = root.entries.length - 1;
        root.selectedIndex = n;
    } 

    onIsOpenChanged: {
        if (root.isOpen) {
            root.selectedIndex = 0;
        }
    }

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

                topLeftRadius: 25
                topRightRadius: 25
                bottomLeftRadius: 15
                bottomRightRadius: 15

                anchors.centerIn: parent

                Keys.onUpPressed: root.moveSelection(-1)
                Keys.onDownPressed: root.moveSelection(1)
                Keys.onPressed: e => {
                    if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) {
                        var entry = root.entries[root.selectedIndex];
                        if (entry) {
                            Clip.copyEntry(entry.id);
                            root.isOpen = false;
                        }
                        e.accepted = true;
                    }
                    if (e.key === Qt.Key_Escape) {
                        root.isOpen = false;
                        e.accepted = true;
                    }
                }

                ClipSearch {}

                Rectangle {
                    id: listRect

                    implicitWidth: parent.width - 16
                    implicitHeight: parent.height - 60

                    radius: 10

                    color: Qt.darker(root.mColor, 0.85)

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 10
                    }

                    ClipList {}
                }

                states: [
                    State {
                        name: "opened"
                        PropertyChanges {
                            target: clipWrapper
                            implicitHeight: 260
                            implicitWidth: 500
                            opacity: 1
                        }
                    },
                    State {
                        name: "closed"
                        PropertyChanges {
                            target: clipWrapper
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
                                target: clipboard
                                property: "visible"
                                value: true
                            }
                            ParallelAnimation {
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "implicitHeight"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "implicitWidth"
                                    duration: 100
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
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: clipWrapper
                                    property: "implicitWidth"
                                    duration: 100
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
}
