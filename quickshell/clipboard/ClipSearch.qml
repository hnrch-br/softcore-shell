import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: searchRect

    anchors {
        horizontalCenter: parent.horizontalCenter
        top: parent.top
        topMargin: 7
    }

    implicitWidth: parent.width - 16
    implicitHeight: 38

    color: root.sColor
    bottomLeftRadius: 10
    bottomRightRadius: 10
    topLeftRadius: 20
    topRightRadius: 20

    Connections {
        target: clipboard

        function onVisibleChanged(): void {
            field.text = ""
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
            root.selectedIndex = 0;
            root.query = text;
        }
    }
}
