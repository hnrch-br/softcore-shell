pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import Quickshell.Wayland

import qs.services

Scope {
    id: root

    readonly property color mColor: "#3a2b2b"
    readonly property color sColor: "#d6c5b2"

    property bool hasPopups: Notifications.popups.rowCount() > 0
    Connections {
        target: Notifications.popups

        function onRowsInserted() {
            root.hasPopups = Notifications.popups.rowCount() > 0
        }
        function onRowsRemoved() {
            root.hasPopups = Notifications.popups.rowCount() > 0
        }
        function onModelReset() {
            root.hasPopups = Notifications.popups.rowCount() > 0
        }
    }

    LazyLoader {
        loading: !root.hasPopups
        PanelWindow {
            id: panel

            anchors {
                top: true
                bottom: true
            }

            implicitWidth: 360
            color: "transparent"
            visible: false

            mask: Region {
                width: panel.width
                height: panel.height
            }

            WlrLayershell.namespace: "notifications"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore

            Item {
                id: wrapper
                state: root.hasPopups ? "popin" : "popout"
                implicitWidth: 360
                implicitHeight: panel.height
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 45
                ListView {
                    id: listView
                    spacing: 3
                    anchors.fill: parent
                    model: Notifications.doNotDisturb ? null : Notifications.popups
                    verticalLayoutDirection: ListView.TopToBottom
                    delegate: NotifCard {}
                    anchors.topMargin: 10

                    add: Transition {
                        NumberAnimation {
                            properties: "y"
                            from: -200
                            duration: 260
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 150
                            easing.type: Easing.OutQuad
                        }
                    }
                    remove: Transition {
                        NumberAnimation {
                            properties: "y"
                            to: -200
                            duration: 260
                            easing.type: Easing.OutQuad
                        }
                        NumberAnimation {
                            property: "opacity"
                            from: 1
                            to: 0
                            duration: 150
                            easing.type: Easing.OutQuad
                        }
                    }
                    displaced: Transition {
                        NumberAnimation {
                            properties: "y"
                            duration: 260
                            easing.type: Easing.OutQuad
                        }
                    }
                }

                states: [
                    State {
                        name: "popin"
                        PropertyChanges {
                            target: wrapper
                            opacity: 1
                        }
                    },
                    State {
                        name: "popout"
                        PropertyChanges {
                            target: wrapper
                            opacity: 0
                        }
                    }
                ]
                transitions: [
                    Transition {
                        from: "popout"
                        to: "popin"
                        SequentialAnimation {
                            PropertyAction {
                                target: panel
                                property: "visible"
                                value: true
                            }
                            NumberAnimation {
                                target: wrapper
                                property: "opacity"
                                duration: 380
                            }
                        }
                    },
                    Transition {
                        from: "popin"
                        to: "popout"
                        SequentialAnimation {
                            NumberAnimation {
                                target: wrapper
                                property: "opacity"
                                duration: 380
                            }
                            PropertyAction {
                                target: panel
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
