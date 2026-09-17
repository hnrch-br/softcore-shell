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

        readonly property string appIcon: itemDelegate.modelData.appIcon
            ? Quickshell.iconPath(itemDelegate.modelData.appIcon, true)
            : Quickshell.iconPath("image-missing", true)
        readonly property string image: itemDelegate.modelData.image
        readonly property string appName: itemDelegate.modelData.appName
        readonly property string summary: itemDelegate.modelData.summary
        readonly property string body: itemDelegate.modelData.body
        readonly property string timeStamp: itemDelegate.modelData.timeStamp
        property bool isExpanded: false

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        implicitWidth: notifCard.isExpanded
            ? 300
            : Math.min(appIcon.implicitWidth + appName.implicitWidth + 40, 280)
        implicitHeight: notifCard.isExpanded
            ? Math.min(contentCol.implicitHeight + 10, 280)
            : 45
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
            spacing: 3
            clip: true
            RowLayout {
                id: titleRow
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 12
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                spacing: 10
                IconImage {
                    id: appIcon
                    source: notifCard.appIcon
                    implicitSize: 22
                    backer.fillMode: Image.PreserveAspectFit
                    backer.smooth: true
                    visible: notifCard.appIcon !== ""
                }
                Item {
                    Layout.alignment: Qt.AlignVCenter
                    implicitWidth: 175
                    implicitHeight: 12
                    Text {
                        id: appName
                        text: notifCard.appName
                        color: root.sColor
                        font {
                            family: "Sixtyfour"
                            pixelSize: 11
                        } 
                        elide: Text.ElideRight
                        anchors {
                            left: parent.left
                            right: parent.right
                        }
                    }
                }
            }
            Text {
                Layout.fillWidth: true
                verticalAlignment: Text.AlignTop
                Layout.leftMargin: 12
                Layout.rightMargin: 12
                text: notifCard.summary
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
                text: notifCard.body
                color: root.sColor
                font {
                    family: "Pixelify Sans"
                    pixelSize: 14
                }
                opacity: notifCard.isExpanded
                elide: Text.ElideRight
                linkColor: Qt.darker("blue", 0.5)
                wrapMode: Text.WordWrap || Text.WrapAnywhere
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }
            }
            Rectangle {
                Layout.preferredWidth: notifCard.image !== "" ? 240 : 0
                Layout.preferredHeight: notifCard.image !== "" ? 135 : 0
                Layout.alignment: Qt.AlignHCenter
                opacity: notifCard.isExpanded
                Layout.bottomMargin: 12
                color: "black"
                visible: notifCard.image !== ""
                radius: 12
                Behavior on opacity {
                    NumberAnimation {
                        duration: 120
                        easing.type: Easing.OutCubic
                    }
                }
                Image {
                    id: appImage
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    source: notifCard.image
                }
            }
        }

        Text {
            id: timeStamp
            verticalAlignment: Text.AlignVCenter
            anchors {
                right: parent.right
                top: parent.top
                topMargin: 12
                rightMargin: 12
            }
            text: notifCard.timeStamp
            color: root.sColor
            font {
                family: "Bytesized"
                pixelSize: 16
            }
            elide: Text.ElideRight
            opacity: notifCard.isExpanded

            Behavior on opacity {
                NumberAnimation { duration: 120 }
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
