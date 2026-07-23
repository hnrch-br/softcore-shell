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

    property int expandedIndex: -1

    readonly property color mColor: "#423d3636"
    readonly property color sColor: "#ccfaebd7"
 
    property string pskInput: ""

    Rectangle {
        implicitWidth: 275
        implicitHeight: 445
        radius: 10
        color: root.mColor
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 15 
        clip: true

        ListView {
            model: Network.networks
            spacing: 2
            anchors.fill: parent
            clip: true

            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
                width: 3
            }

            delegate: Rectangle {
                id: row
                required property var modelData
                required property int index

                property bool isExpanded: root.expandedIndex === index

                readonly property bool connecting: modelData.state === Network.stateConnecting
                readonly property bool disconnecting: modelData.state === Network.stateDisconnecting

                readonly property bool requiresPsk:
                    modelData.security === Network.securityWpaPsk ||
                    modelData.security === Network.securityWpa2Psk ||
                    modelData.security === Network.securitySae

                property bool showPskField: requiresPsk && !modelData.known

                Connections {
                    target: row.modelData
                    function onConnectionFailed(reason) {
                        if (reason === Network.failReasonNoSecrets)
                            row.showPskField = true
                    }
                }

                Behavior on implicitHeight {
                    NumberAnimation { duration: 100; easing.type: Easing.OutQuad }
                }

                implicitWidth: ListView.view.width
                implicitHeight: isExpanded ? 100 : 45
                radius: 4
                color: listMA.containsMouse 
                    ? Qt.tint(root.sColor, "#cced752b") 
                    : Qt.alpha(root.mColor, 0.6)
                
                Text {
                    id: netName
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    anchors.verticalCenterOffset: row.isExpanded ? -30 : 0
                    text: Network.networkLabel
                    font {
                        family: "Pixelify Sans"
                        pixelSize: 12
                    }
                    color: listMA.containsMouse 
                        ? Qt.alpha(root.mColor, 1.0)
                        : Qt.alpha(root.sColor, 0.8)
                }
                Text {
                    visible: parent.isExpanded
                    id: netStatus
                    text: row.modelData.connecting
                        ? "Connecting..."
                        : row.modelData.disconnecting
                        ? "Disconnecting..."
                        : row.modelData.connected
                        ? "Connected"
                        : row.modelData.known
                        ? "Saved"
                        : "" 
                    font {
                        family: "Pixelify Sans"
                        pixelSize: 14
                    }
                    color: listMA.containsMouse ? Qt.alpha(root.mColor, 1.0) : Qt.tint(Qt.alpha(root.sColor, 0.8), "#cced752b")
                    anchors.bottom: netName.bottom
                    anchors.bottomMargin: -25
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                }

                Rectangle {
                    z: 1
                    id: pskField
                    visible: row.isExpanded && row.showPskField 
                    implicitWidth: parent.width - 8
                    implicitHeight: 28
                    radius: 6
                    color: Qt.alpha(root.mColor, 0.8)
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    Rectangle { 
                        implicitWidth: parent.width - 12
                        implicitHeight: 1
                        radius: 99
                        color: Qt.alpha(root.sColor, 0.4)
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    TextField { 
                        anchors.fill: parent
                        anchors.leftMargin: 2
                        anchors.rightMargin: 2
                        
                        text: root.pskInput
                        onTextChanged: if (text !== root.pskInput) root.pskInput = text

                        background: null
                        color: Qt.tint(Qt.alpha(root.sColor, 0.8), "#cced752b")
                        placeholderText: "Password"
                        placeholderTextColor: Qt.alpha(root.sColor, 0.8)
                        font {
                            family: "Bytesized"
                            pixelSize: 16
                        }
                        passwordCharacter: "*"
                        passwordMaskDelay: 0
                        echoMode: row.isExpanded ? TextInput.Password : TextInput.Normal
                        selectByMouse: true
                        verticalAlignment: TextInput.AlignVCenter
                    }

                }

                MouseArea {
                    id: listMA
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    hoverEnabled: true
                    onClicked: root.expandedIndex = (root.expandedIndex === row.index) ? -1 : row.index
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
        command: ["qs", "ipc", "call", "netList", "goBack"]
    } 
}

