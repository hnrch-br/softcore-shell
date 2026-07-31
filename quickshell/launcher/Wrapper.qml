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
    property color mColor: "#3a2b2b"
    property color sColor: "#ccfaebd7"

    readonly property var appEntries: {
        var src = DesktopEntries.applications.values;
        var out = [];
        for (var i = 0; i < src.length; i++)
        if (src[i] && !src[i].noDisplay) out.push(src[i]);
        return out;
    }

    function moveSelection(delta) {
        if (root.entries.length === 0) return;
        var n = root.selectedIndex + delta;
        if (n < 0) n = 0;
        if (n > root.entries.length - 1) n = root.entries.length - 1;
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
        if (isOpen) {
            query = "";
            selectedIndex = 0;
            results;
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
            
            onVisibleChanged: {
                if (visible) { 
                    field.forceActiveFocus();
                    field.text = "";
                }
            }

            anchors {
                bottom: true
                right: true
                left:true
                top: true
            }

            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.namespace: "launcher"

            exclusionMode: ExclusionMode.Ignore

            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

            color: "transparent"

            IpcHandler {
                target: "launcher"

                function toggleVisible(): void {
                    root.isOpen = !root.isOpen;
                }
            }  

            visible: root.isOpen

            Rectangle {
                id: wrapper

                color: root.mColor
                
                function focusField() { field.forceActiveFocus(); }
                property alias query: field.text

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom

                implicitWidth: 500
                implicitHeight: 320
                topLeftRadius: 25
                topRightRadius: 25

                Rectangle {
                    implicitWidth: parent.width - 20
                    implicitHeight: 45

                    color: root.sColor
                    radius: 15

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 10
                    }

                    TextField {
                        id: field
                        anchors {
                            left: parent.left 
                            right: parent.right
                            verticalCenter: parent.verticalCenter
                            leftMargin: 13
                            rightMargin: 13
                        }
                        background: null
                        color: Qt.alpha(root.mColor, 0.8)
                        font { family: "Bytesized"; pixelSize: 18 }
                        placeholderText: "Search"
                        placeholderTextColor: root.mColor
                        selectByMouse: true
                        focus: true

                        cursorDelegate: Rectangle {
                            width: 2
                            color: Qt.alpha(root.mColor, 0.4)
                            visible: field.cursorVisible
                        }

                        onTextChanged: {
                            root.query = text;
                            root.selectedIndex = 0;
                        }

                        Keys.onUpPressed: root.moveSelection(-1)
                        Keys.onDownPressed: root.moveSelection(1)
                        Keys.onPressed: (e) => {
                            if (e.key === Qt.Key_Return || e.key === Qt.Key_Enter) {
                                root.run(root.entries[root.selectedIndex]);
                                e.accepted = true;
                            } else if (e.key === Qt.Key_Escape) {
                                root.isOpen = false;
                                e.accepted = true;
                            }
                        }
                    }
                }

                Rectangle {
                    implicitWidth: parent.width - 20
                    implicitHeight: parent.height - 75
            
                    clip: true
    
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        bottom: parent.bottom
                        bottomMargin: 10
                    }

                    radius: 12
                    color: Qt.alpha("#593c30", 0.75)

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
    }
}
