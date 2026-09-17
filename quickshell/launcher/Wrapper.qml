pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Widgets
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Shapes
import QtQuick.Effects

import "root:/services/scripts/fuzzy.js" as Fuzzy

Scope {
    id: root

    property string query: ""
    property var usage: ({})
    readonly property var results: Fuzzy.rank(appEntries, query, usage)
    property bool isOpen: false
    readonly property color mColor: "#3a2b2b"
    readonly property color sColor: "#d6c5b2"

    readonly property var appEntries: {
        var src = DesktopEntries.applications.values;
        var out = [];
        for (var i = 0; i < src.length; i++)
            if (src[i] && !src[i].noDisplay)
                out.push(src[i]);
        return out;
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

    function run(entry) {
        if (entry) {
            if (entry.id) {
                root.usage[entry.id] = (root.usage[entry.id] || 0) + 1;
                usageStore.setText(JSON.stringify(root.usage));
                usageStore.waitForJob();
            }
            entry.execute();
        }
        root.isOpen = false;
    }

    Component.onCompleted: {
        var raw = usageStore.text();
        try {
            root.usage = raw && raw.length ? JSON.parse(raw) : ({});
        } catch (e) {
            root.usage = ({});
        }
    }

    onIsOpenChanged: {
        if (root.isOpen) {
            query = "";
            selectedIndex = 0;
        }
    }

    IpcHandler {
        target: "launcher"

        function toggleVisible(): void {
            root.isOpen = !root.isOpen;
        }
    }

    FileView {
        id: usageStore
        path: Quickshell.env("HOME") + "/.cache/recent-apps.json"
        blockLoading: true
        atomicWrites: true
        printErrors: false
    }

    property var entries: results
    property int selectedIndex: 0

    LazyLoader {
        loading: !root.isOpen

        PanelWindow {
            id: launcher

            anchors.bottom: true

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "launcher"

            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            color: "transparent"

            implicitWidth: 560
            implicitHeight: 320 

            visible: false

            Rectangle {
                id: wrapper

                color: root.mColor
                state: root.isOpen ? "opened" : "closed"

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom

                topLeftRadius: 25
                topRightRadius: 25

                Keys.onUpPressed: root.moveSelection(-1)
                Keys.onDownPressed: root.moveSelection(1)
                Keys.onPressed: e => {
                    if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) {
                        root.run(root.entries[root.selectedIndex]);
                        e.accepted = true;
                    } else if (e.key === Qt.Key_Escape) {
                        root.isOpen = false;
                        e.accepted = true;
                    }
                }

                SearchBar {}

                Rectangle {
                    id: listRect
                    implicitWidth: parent.width - 20
                    implicitHeight: parent.height - 75

                    clip: true

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 10
                    }

                    radius: 12
                    color: Qt.darker(root.mColor, 0.85)

                    AppList {}
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
                            target: wrapper
                            implicitHeight: 320
                            implicitWidth: 500
                            opacity: 1
                        }
                    },
                    State {
                        name: "closed"
                        PropertyChanges {
                            target: wrapper
                            implicitHeight: 0
                            implicitWidth: 100
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
                                target: launcher
                                property: "visible"
                                value: true
                            }
                            ParallelAnimation {
                                NumberAnimation {
                                    target: wrapper
                                    property: "implicitHeight"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: wrapper
                                    property: "implicitWidth"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: wrapper
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
                                    target: wrapper
                                    property: "implicitHeight"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: wrapper
                                    property: "implicitWidth"
                                    duration: 150
                                    easing.type: Easing.OutQuad
                                }
                                NumberAnimation {
                                    target: wrapper
                                    property: "opacity"
                                    duration: 200
                                    easing.type: Easing.OutQuad
                                }
                            }
                            PropertyAction {
                                target: launcher
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

        readonly property real radius: 30

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
