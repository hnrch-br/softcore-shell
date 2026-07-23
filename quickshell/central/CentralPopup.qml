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

PanelWindow {
    id: root

    property bool isOpen: false
    readonly property color mColor: "#423d3636"
    readonly property color sColor: "#ccfaebd7"

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "centralPopup"
    exclusionMode: ExclusionMode.Ignore

    property string activeView: "main"

    HyprlandFocusGrab {
        active: root.isOpen
        windows: [root]
        onCleared: closeAnim.start()
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
        onActivated: closeAnim.start()
    }

    visible: root.isOpen
    color: "transparent"

    anchors {
        top: true
        right: true
    }

    margins.top: 35

    implicitWidth: 325
    implicitHeight: 500

    Rectangle {
        id: centralWrapperOuter

        anchors.right: parent.right
        implicitWidth: root.isOpen ? 300 : 1
        implicitHeight: root.isOpen ? 475 : 1
        color: root.mColor
        topRightRadius: 25
        topLeftRadius: 0
        bottomLeftRadius: 10
        bottomRightRadius: 0
        opacity: root.isOpen ? 1 : 0

        clip: true

        MainPanel { id: mainPanel; visible: root.activeView === "main" }

        NetList { id: netList; visible: root.activeView === "net" }

        BtList { id: btList; visible: root.activeView === "bt" }

        Behavior on implicitWidth {
            NumberAnimation { 
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Behavior on implicitHeight {
            NumberAnimation { 
                duration: 150
                easing.type: Easing.OutQuad 
            }
        }
    }

    Corner {
        id: cornerLeftTop
        anchors.top: centralWrapperOuter.top
        anchors.left: centralWrapperOuter.left
        anchors.leftMargin: -radius
        rotation: 90
    }

    Corner {
        id: cornerRightBottom
        anchors.bottom: centralWrapperOuter.bottom
        anchors.right: centralWrapperOuter.right
        anchors.bottomMargin: -radius
        rotation: 90
    }

    SequentialAnimation {
        id: closeAnim
        ParallelAnimation {
            NumberAnimation {
                target: centralWrapperOuter
                property: "implicitHeight"
                to: 0
                duration: 200
                easing.type: Easing.OutQuad
            }
            NumberAnimation {
                target: centralWrapperOuter
                property: "implicitWidth"
                to: 0
                duration: 150
                easing.type: Easing.OutQuad
            }
        }
        ScriptAction {
            script: {
                root.isOpen = false;
            }
        }
    } 

    IpcHandler {
        target: "netList"

        function toggleVisible(): void {
            root.activeView = "net"
        }

        function goBack(): void {
            root.activeView = "main"
        }
    }

    IpcHandler {
        target: "btList"

        function toggleVisible(): void {
            root.activeView = "bt"
        }

        function goBack(): void {
            root.activeView = "main"
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
