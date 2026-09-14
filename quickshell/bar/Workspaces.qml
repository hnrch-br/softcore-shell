pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

import qs.services

Item {
    id: wsRoot

    implicitWidth: wsRow.implicitWidth
    implicitHeight: wsRow.implicitHeight
    clip: true

    Behavior on implicitWidth {
        NumberAnimation { 
            duration: 50
            easing.type: Easing.OutQuad
        }
    }

    property real wheelAccumulator: 0

    Timer {
        id: wsWheelTimer
        interval: 200
        onTriggered: wsRoot.wheelAccumulator = 0
    }

    WheelHandler {
        acceptedModifiers: Qt.NoModifier
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (wheel) => {
            wsWheelTimer.restart();
            wsRoot.wheelAccumulator -= wheel.angleDelta.y;

            const threshold = 120;
            if (Math.abs(wsRoot.wheelAccumulator) < threshold) return;

            const steps = Math.trunc(wsRoot.wheelAccumulator / threshold);
            wsRoot.wheelAccumulator = wsRoot.wheelAccumulator % threshold;
            
            const list = Hypr.workspaces;
            const count = Hypr.workspaceCount;
            if (count <= 1) return;

            let curIdx = list.findIndex(w => w.id === Hypr.focusedId);
            if (curIdx < 0)
                curIdx = steps > 0 ? count - 1 : 0;

            const nextIdx = ((curIdx + steps) % count + count) % count;
            const idx = list[nextIdx].id;

            if (idx !== Hypr.focusedId) {
                Hypr.focusWorkspace(idx);
            }
        }
    }

    RowLayout {
        id: wsRow
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6 
        Repeater {
            id: wsRepeater

            model: ScriptModel {
                values: Hypr.workspaces
            }

            delegate: Rectangle {
                id: wsRect 
                required property var modelData
                property bool isFocused: wsRect.modelData.id === Hypr.focusedId

                radius: 3
                implicitWidth: wsRect.isFocused ? 26 : mousearea.containsMouse ? 26 : 10
                implicitHeight: wsRect.isFocused ? 24 : mousearea.containsMouse ? 24 : 20
                color: wsRect.isFocused
                    ? root.sColor
                    : Qt.darker(root.mColor, 0.75)

                Behavior on implicitWidth {
                    NumberAnimation {
                        duration: 50
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on implicitHeight {
                    NumberAnimation {
                        duration: 50
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation { 
                        duration: 50;
                        easing.type: Easing.OutQuad
                    }
                }
                
                Text {
                    visible: wsRect.isFocused
                    text: wsRect.modelData.id
                    anchors {
                        centerIn: parent
                    }
                    leftPadding: 3
                    color: root.mColor
                    font {
                        pixelSize: 18
                        family: "Bytesized"
                    }
                }

                MouseArea {
                    id: mousearea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hypr.focusWorkspace(wsRect.modelData.id)
                }
            }
        }
    }
}
