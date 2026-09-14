pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Effects
import Quickshell.Widgets
import QtQuick.Layouts

Item {
    id: itemDelegate
    implicitWidth: 360
    implicitHeight: notifCard.implicitHeight
    required property var modelData

    Rectangle {
        id: notifCard

        property bool isExpanded: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 15
        implicitWidth: notifCard.isExpanded ? 280 : 160
        implicitHeight: notifCard.isExpanded ? contentCol.implicitHeight + 10 : 45
        color: root.mColor
        radius: 12

        Behavior on implicitHeight {
            NumberAnimation {
                duration: 150
                easing.type: Easing.OutQuad
            }
        }

        Behavior on implicitWidth {
            NumberAnimation {
                duration: 100
                easing.type: Easing.OutCubic
            }
        }

        Shadow {}
 
        ColumnLayout {
            id: contentCol
            anchors.fill: parent
            spacing: 4
            clip: true
            RowLayout {
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                Layout.topMargin: 12
                Layout.leftMargin: notifCard.isExpanded ? 12 : 23
                spacing: 15
                IconImage {
                    id: appImage
                    backer.visible: appImage.source !== ""
                    source: { 
                        itemDelegate.modelData.image || itemDelegate.modelData.appIcon
                    }
                    implicitSize: 22
                    backer.fillMode: Image.PreserveAspectFit
                    backer.smooth: true
                    
                }
                Item {
                    implicitWidth: appName.implicitWidth
                    implicitHeight: appName.implicitHeight
                    Layout.alignment: Qt.AlignVCenter
                    Text {
                        id: appName
                        anchors.left: parent.left
                        anchors.right: parent.right
                        text: itemDelegate.modelData.appName
                        color: root.sColor
                        font {
                            family: "Sixtyfour"
                            pixelSize: 11
                        } 
                        elide: Text.ElideRight
                    }
                } 
            }
            Text {
                Layout.fillWidth: true
                verticalAlignment: Text.AlignTop
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                text: itemDelegate.modelData.summary
                color: root.sColor
                font {
                    family: "Pixelify Sans"
                    pixelSize: 16
                }
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                opacity: notifCard.isExpanded
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Text {
                Layout.fillWidth: true
                Layout.fillHeight: true
                verticalAlignment: Text.AlignTop
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                text: itemDelegate.modelData.body
                color: root.sColor
                font {
                    family: "Pixelify Sans"
                    pixelSize: 14
                }
                opacity: notifCard.isExpanded
                elide: Text.ElideRight
                wrapMode: Text.WordWrap
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth: 240
                Layout.preferredHeight: 135
                Layout.alignment: Qt.AlignHCenter
                opacity: notifCard.isExpanded
                Layout.bottomMargin: 12
                color: "black"
                radius: 12
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }
                Image {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: itemDelegate.modelData.image                    
                }
            }
        }

        MouseArea {
            anchors.fill: parent
            id: notifMA
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onEntered: itemDelegate.modelData.togglePause()
            onExited: itemDelegate.modelData.togglePause()
            onClicked: notifCard.isExpanded = !notifCard.isExpanded
        }

        component Shadow: RectangularShadow {
            z: -1
            anchors.fill: parent
            color: "black"
            spread: 0.5
            blur: 30
            offset.x: 0
            offset.y: 5
        }
    }
}
