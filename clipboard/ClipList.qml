pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import qs.services

ListView {
    id: clipList
    anchors.fill: parent
    spacing: 2
    clip: true
    boundsBehavior: Flickable.StopAtBounds
    model: root.entries
    anchors.horizontalCenter: parent.horizontalCenter

    Connections {
        target: root
        function onSelectedIndexChanged() {
            clipList.positionViewAtIndex(root.selectedIndex, ListView.Contain);
        }
    }

    delegate: Rectangle {
        id: clipRow

        required property int index
        property var entry: root.entries[index]
        property bool isSelected: index === root.selectedIndex

        color: isSelected ? Qt.tint(root.sColor, "#cced752b") : "transparent"
        implicitWidth: 484
        implicitHeight: isSelected ? 60 : 50
        radius: 10

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 140
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
            anchors.leftMargin: clipRow.isSelected ? 20 : 8
            anchors.rightMargin: 8
            spacing: 10

            Behavior on anchors.leftMargin {
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.OutQuad
                }
            }

            Image {
                id: entryImg
                visible: entry.previewSource !== ""
                source: entry.previewSource
                Layout.preferredWidth: isSelected ? 58 : 50
                Layout.preferredHeight: isSelected ? 58 : 50
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            Text {
                id: entryTxt
                Layout.fillWidth: true
                elide: Text.ElideRight
                text: entry.content
                color: Qt.alpha(root.sColor, 1.0)
                font.family: "Pixelify Sans"
                font.pixelSize: 16
            }
        }

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onEntered: root.selectedIndex = clipRow.index
            onExited: {
                if (root.selectedIndex === clipRow.index)
                   return root.selectedIndex = -1;
            }
            onClicked: {
                Clip.copyEntry(entry.id);
                root.isOpen = false;
            }
        }
    }
}
