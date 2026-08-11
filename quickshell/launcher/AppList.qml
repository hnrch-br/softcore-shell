pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import QtQuick.Effects

ListView {
    id: appList
    anchors.fill: parent
    spacing: 2
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    model: root.entries.length

    Connections {
        target: root
        function onSelectedIndexChanged() {
            appList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
        }
    }

    delegate: Rectangle {
        id: listRow
        required property int index
        property var entry: root.entries[index]
        property bool isSelected: index === root.selectedIndex

        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: isSelected ? appList.width : appList.width - 20
        implicitHeight: isSelected ? 46 : 42
        radius: 10
        color: isSelected ? Qt.tint(root.sColor, "#cced752b") : "transparent"

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutQuad
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 140
                easing.type: Easing.OutQuad
            }
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 8
            anchors.rightMargin: 8
            spacing: 10

            IconImage {
                implicitSize: 32
                source: listRow.entry ? Quickshell.iconPath(listRow.entry.icon, true) : ""
                backer.fillMode: Image.PreserveAspectCrop
                backer.smooth: true
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: listRow.isSelected ? "transparent" : Qt.tint(Qt.alpha(root.mColor, 0.5), "#cced752b")
                }
                asynchronous: true
            }

            Text {
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: listRow.entry ? listRow.entry.name : ""
                color: listRow.isSelected ? Qt.alpha(root.mColor, 1.0) : root.sColor
                font.family: "Pixelify Sans"
                font.pixelSize: 16
            }
        }

        MouseArea {
            id: listRowMA
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onEntered: root.selectedIndex = listRow.index
            onClicked: root.run(listRow.entry)
            onExited: {
                if (root.selectedIndex === listRow.index)
                    return root.selectedIndex = -1;
            }
        }
    }
}
