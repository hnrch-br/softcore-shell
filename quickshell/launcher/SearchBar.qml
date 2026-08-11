pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: fieldRect
    implicitWidth: parent.width - 20
    implicitHeight: 45

    color: root.sColor
    radius: 15

    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        topMargin: 10
    }

    property alias query: field.text

    Connections {
        target: launcher

        function onVisibleChanged(): void {
            field.text = "";
        }
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
        font {
            family: "Bytesized"
            pixelSize: 18
        }
        placeholderText: "Search"
        placeholderTextColor: Qt.alpha(root.mColor, 0.6)
        selectByMouse: true
        focus: true

        cursorDelegate: Rectangle {
            id: cursorDelegate
            width: 2
            color: Qt.alpha(root.mColor, 0.4)

            Timer {
                id: blinkTimer
                interval: 600
                running: true
                repeat: true
                onTriggered: cursorDelegate.visible = !cursorDelegate.visible
            }

            Timer {
                id: idleBlinkTimer
                interval: 500
                onTriggered: blinkTimer.start()
            }

            function resetBlink(): void {
                blinkTimer.stop();
                cursorDelegate.visible = true;
                idleBlinkTimer.restart();
            }

            Connections {
                target: field
                function onTextChanged(): void {
                    cursorDelegate.resetBlink();
                }
                function onCursorPositionChanged(): void {
                    cursorDelegate.resetBlink();
                }
            }
        }

        onTextChanged: {
            root.query = text;
            root.selectedIndex = 0;
        }
    }
}
