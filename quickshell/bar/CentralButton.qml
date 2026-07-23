import QtQuick
import Quickshell
import QtQuick.Layouts

RowLayout {
    id: root

    readonly property color mColor: "#ccfaebd7"
    readonly property color sColor: "#ff3d3636"

    Rectangle {
        id: centralRect

        implicitWidth: 32
        implicitHeight: 20
        bottomLeftRadius: 2
        topLeftRadius: 2
        bottomRightRadius: 25
        topRightRadius: 25

        color: root.mColor

        RowLayout {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                id: homeIcon
                text: "home"
                font { family: "Material Symbols Rounded"; pointSize: 12 }
                color: root.sColor
                rightPadding: 1
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: Quickshell.execDetached(["qs", "ipc", "call", "centralPopup", "toggleVisible"])
        }
    }
}
