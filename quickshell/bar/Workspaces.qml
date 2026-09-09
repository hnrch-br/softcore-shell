pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts

import qs.services

Item {
    id: root 

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
        onTriggered: root.wheelAccumulator = 0
    }

    WheelHandler {
        acceptedModifiers: Qt.NoModifier
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        onWheel: (wheel) => {
            wsWheelTimer.restart();
            root.wheelAccumulator -= wheel.angleDelta.y;

            const threshold = 120;
            if (Math.abs(root.wheelAccumulator) < threshold) return;

            const steps = Math.trunc(root.wheelAccumulator / threshold);
            root.wheelAccumulator = root.wheelAccumulator % threshold;
            
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
                implicitWidth: wsRect.isFocused ? 18 : 10
                implicitHeight: wsRect.isFocused ? 24 : 20
                color: wsRect.isFocused
                    ? "#ccfaebd7"
                    : "#cc3d3636"

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
            }
        }
    }
}
