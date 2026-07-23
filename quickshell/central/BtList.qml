pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls

import qs.services
import qs.central.components

ColumnLayout {
    id: root

    Layout.fillWidth: true
    Layout.fillHeight: true
    anchors.horizontalCenter: parent.horizontalCenter
    visible: false
    spacing: 5

    readonly property color mColor: "#423d3636"
    readonly property color sColor: "#ccfaebd7"

    property int size: 25

    RowLayout {
        Layout.topMargin: 15
        Layout.alignment: Qt.AlignHCenter
        spacing: 3
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 89
            implicitHeight: 48
            radius: 5
            color: statusMA.containsMouse 
                ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
                : Qt.alpha(root.mColor, 0.8)
            
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                spacing: 0
                Text {
                    text: Bluetooth.btIcon
                    font {
                        family: "Material Symbols Outlined"
                        pointSize: 14
                    }
                    color: statusMA.containsMouse
                        ? Qt.alpha(root.mColor, 1.0)
                        : Qt.alpha(root.sColor, 0.8)
                }
                Text {
                    text: Bluetooth.btStatus
                    font {
                        family: "Pixelify Sans"
                        pixelSize: 15
                    }
                    color: statusMA.containsMouse
                        ? Qt.alpha(root.mColor, 1.0)
                        : Qt.alpha(root.sColor, 0.8)
                }
            }

            MouseArea {
                id: statusMA
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Bluetooth.toggleEnabled()
            }
        }
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 89
            implicitHeight: 48
            radius: 5
            color: scanningMA.containsMouse
                ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
                : Qt.alpha(root.mColor, 0.8)
            
            RowLayout {
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.right: parent.right
                spacing: 0
                Text {
                    text: Bluetooth.scanningIcon
                    font {
                        family: "Material Symbols Outlined"
                        pointSize: 14
                    }
                    color: scanningMA.containsMouse
                        ? Qt.alpha(root.mColor, 1.0)
                        : Qt.alpha(root.sColor, 0.8)
                }
                Text {
                    text: Bluetooth.scanningStatus
                    font {
                        family: "Pixelify Sans"
                        pixelSize: 15
                    }
                    color: scanningMA.containsMouse
                        ? Qt.alpha(root.mColor, 1.0)
                        : Qt.alpha(root.sColor, 0.8)
                }
            }

            MouseArea {
                id: scanningMA
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Bluetooth.toggleScanning()
            }
        }
        Rectangle {
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 89
            implicitHeight: 48
            radius: 5
            color: discoverMA.containsMouse
                ? Qt.tint(Qt.alpha(root.sColor, 1.0), "#cced752b")
                : Qt.alpha(root.mColor, 0.8)
            
            RowLayout {
                anchors.centerIn: parent
                spacing: 0
                Text {
                    text: Bluetooth.discoverStatus
                    font {
                        family: "Pixelify Sans"
                        pixelSize: 15
                    }
                    color: discoverMA.containsMouse
                        ? Qt.alpha(root.mColor, 1.0)
                        : Qt.alpha(root.sColor, 0.8)
                }
            }

            MouseArea {
                id: discoverMA
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: Bluetooth.toggleDiscoverable()
            }
        }
    }

    Rectangle {
        implicitWidth: 275
        implicitHeight: 395
        radius: 10
        color: root.mColor
        Layout.alignment: Qt.AlignHCenter 
        ColumnLayout {
            anchors.fill: parent
            spacing: 4
            ListView {
                id: pairedList
                model: Bluetooth.pairedDevices
                Layout.fillWidth: true
                Layout.fillHeight: false
                implicitHeight: contentHeight
                spacing: 2

                delegate: Rectangle {
                    id: pairedRow
                    required property var modelData

                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: parent.width
                    implicitHeight: 38
                    radius: 4
                    color: pairedHover.hovered 
                        ? Qt.tint(root.sColor, "#cced752b") 
                        : Qt.alpha(root.mColor, 0.6)

                    Rectangle {
                        z: 1
                        opacity: pairedHover.hovered
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        implicitHeight: 38
                        implicitWidth: pairedHover.hovered ? 68 : 1
                        radius: 4
                        color: Qt.alpha(root.mColor, 0.3)
                        Behavior on opacity {
                            NumberAnimation { duration: 100 }
                        }
                        Behavior on implicitWidth {
                            NumberAnimation { duration: 100 }
                        }
                        RowLayout {
                            spacing: 7
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.right: parent.right
                            anchors.rightMargin: 4
                            Rectangle {
                                implicitWidth: root.size
                                implicitHeight: root.size
                                radius: 8
                                color: Qt.alpha(root.mColor, 0.6)

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: pairedRow.modelData.connected
                                        ? pairedRow.modelData.disconnect()
                                        : pairedRow.modelData.connect()
                                }

                                Text {
                                    anchors.centerIn: parent
                                    text: pairedRow.modelData.connected ? "link_off" : "link"
                                    font {
                                        family: "Material Symbols Outlined"
                                        pointSize: 8
                                    }
                                    color: root.sColor
                                }
                            }
                            Rectangle {
                                implicitWidth: root.size
                                implicitHeight: root.size
                                radius: 8
                                color: Qt.alpha(root.mColor, 0.6)

                                MouseArea {
                                    anchors.fill: parent
                                    cursorShape: Qt.PointingHandCursor
                                    onClicked: pairedRow.modelData.forget()
                                    
                                    Text {
                                        anchors.centerIn: parent
                                        text: "remove"
                                        font {
                                            family: "Material Symbols Outlined"
                                            pointSize: 8
                                        }
                                        color: root.sColor
                                    }
                                }
                            }
                        }
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: pairedRow.modelData.name || pairedRow.modelData.address
                        font {
                            family: "Pixelify Sans"
                            pixelSize: 12
                        }
                        color: pairedHover.hovered
                            ? Qt.alpha(root.mColor, 1.0)
                            : Qt.alpha(root.sColor, 0.8)
                        elide: Text.ElideRight
                    }
                    HoverHandler {
                        id: pairedHover
                    }
                }
            }
            
            Rectangle {
                implicitWidth: 275
                implicitHeight: 1
                color: Qt.alpha(root.mColor, 0.9)
                Layout.alignment: Qt.AlignHCenter
                visible: pairedList.count > 0
            }

            ListView {
                id: unpairedList
                model: Bluetooth.devices
                opacity: Bluetooth.scanning
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 2

                ScrollBar.vertical: ScrollBar {
                    policy: ScrollBar.AsNeeded
                    width: 3
                }

                delegate: Rectangle {
                    id: listRow
                    required property var modelData

                    anchors.horizontalCenter: parent.horizontalCenter
                    implicitWidth: parent.width
                    implicitHeight: 38
                    radius: 4
                    color: listHover.hovered 
                        ? Qt.tint(root.sColor, "#cced752b") 
                        : Qt.alpha(root.mColor, 0.6)

                    MouseArea {
                        anchors.fill: parent
                        onClicked: listRow.modelData.connected
                            ? listRow.modelData.disconnect()
                            : listRow.modelData.connect()
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left
                        anchors.leftMargin: 5
                        text: listRow.modelData.name || listRow.modelData.address
                        font {
                            family: "Pixelify Sans"
                            pixelSize: 12
                        }
                        color: listHover.hovered 
                            ? Qt.alpha(root.mColor, 1.0)
                            : Qt.alpha(root.sColor, 0.8)
                    }
                    HoverHandler {
                        id: listHover
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }
        }

        Rectangle {
            anchors {
                bottom: parent.bottom
                left: parent.left
                bottomMargin: 10
                leftMargin: 10
            }
            readonly property int size: 45
            implicitWidth: size
            implicitHeight: size
            radius: size
            color: Qt.alpha(root.mColor, 0.8)

            Text {
                text: "arrow_back_ios_new"
                font {
                    family: "Material Symbols Outlined"
                    pointSize: 12.2
                }
                anchors.centerIn: parent
                color: root.sColor
                rightPadding: 2
            } 

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: goBackProc.running = true
            }
        }
                
    }

    Process {
        id: goBackProc
        command: ["qs", "ipc", "call", "btList", "goBack"]
    } 
}
