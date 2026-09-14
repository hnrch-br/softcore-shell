pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
Item {
    z: 1
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 10

    Rectangle {
        id: dropdown
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
        anchors.topMargin: 15

        implicitHeight: 160
        implicitWidth: 150

        radius: 3

        state: "closed"
        color: root.sColor

        readonly property int span: 12

        Connections {
            target: root

            function onIsExpandedChanged(): void {
                dropdown.state = "closed"
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 2
            ListView {
                id: monthPicker
                model: dropdown.span

                verticalLayoutDirection: ListView.BottomToTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                currentIndex: root.month
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: (monthPicker.height / 2) - 12
                preferredHighlightEnd: (monthPicker.height / 2) + 12
                snapMode: ListView.SnapToItem

                delegate: Rectangle {
                    id: monthRect
                    required property int index
                    width: monthPicker.width
                    height: (monthPicker.currentIndex === monthRect.index) ? 28 : 18
                    color: "transparent" 

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.month = monthRect.index
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: Qt.locale().standaloneMonthName(index, Locale.ShortFormat)
                        color: root.mColor
                        font {
                            pixelSize: {
                                var d = Math.abs(monthRect.index - monthPicker.currentIndex);
                                const maxS = 20;
                                const minS = 10;
                                const step = 4;
                                return Math.max(minS, maxS - d * step);
                            }
                            family: "Pixelify Sans"
                        }
                    }
                }
            }
            ListView {
                id: yearPicker
                model: {
                    var years = [];
                    const curyear = root.year;
                    for (let i = startYear; i <= root.year + 5; i++) {
                        years.push(i);
                    }
                    return years;
                }

                readonly property int startYear: root.year - 10

                verticalLayoutDirection: ListView.BottomToTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                currentIndex: root.year - startYear
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: (yearPicker.height / 2) - 12
                preferredHighlightEnd: (yearPicker.height / 2) + 12
                snapMode: ListView.SnapToItem

                delegate: Rectangle {
                    id: yearRect
                    required property int index
                    required property var modelData
                    width: yearPicker.width
                    height: (yearPicker.currentIndex === yearRect.index) ? 28 : 18
                    color: "transparent" 

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.year = yearRect.modelData
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: yearRect.modelData
                        color: root.mColor
                        font {
                            pixelSize: {
                                var d = Math.abs(yearRect.index - yearPicker.currentIndex);
                                const maxS = 20;
                                const minS = 10;
                                const step = 4;
                                return Math.max(minS, maxS - d * step);
                            }
                            family: "Pixelify Sans"
                        }
                    }
                }
            }
        }

        states: [
            State {
                name: "opened"
                PropertyChanges {
                    target: dropdown
                    implicitHeight: 120
                    opacity: 1
                }
            },
            State {
                name: "closed"
                PropertyChanges {
                    target: dropdown
                    implicitHeight: 1
                    opacity: 0
                }
            }
        ]
        transitions: [
            Transition {
                from: "closed"
                to: "opened"
                SequentialAnimation {
                    PropertyAction {
                        target: dropdown
                        property: "visible"
                        value: true
                    }
                    ParallelAnimation {
                        NumberAnimation {
                            target: dropdown
                            property: "implicitHeight"
                            duration: 120
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: dropdown
                            property: "opacity"
                            duration: 130
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            },
            Transition {
                from: "opened"
                to: "closed"
                SequentialAnimation {
                    ParallelAnimation {
                        NumberAnimation {
                            target: dropdown
                            property: "implicitHeight"
                            duration: 120
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            target: dropdown
                            property: "opacity"
                            duration: 100
                            easing.type: Easing.OutQuad
                        }
                    }
                    PropertyAction {
                        target: dropdown
                        property: "visible"
                        value: false
                    }
                }
            }
        ]
    }
    RowLayout {
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        spacing: 2
        Button {
            id: lastMonth
            contentItem: Text {
                text: "arrow_back_ios_new"
                font {
                    family: "Material Symbols Outlined"
                    pointSize: 9
                }
                opacity: 1
                color: lastMonth.down ? root.mTxtColor : root.sTxtColor
                horizontalAlignment: Text.AlignHCenter
                topPadding: 1

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            background: Rectangle {
                id: leftBtnRect
                implicitHeight: 20
                implicitWidth: 25
                bottomLeftRadius: 8
                topLeftRadius: 8
                bottomRightRadius: 2
                topRightRadius: 2
                opacity: root.visible ? 1 : 0
                color: lastMonth.down
                    ? Qt.tint(Qt.alpha(root.mColor, 1.0), "#cced752b")
                    : root.sColor
                anchors.centerIn: parent
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
            onClicked: {
                root.month--;
                if (root.month < 0) {
                    root.month = 11;
                    root.year--;
                }
            }
        }

        Rectangle {
            implicitWidth: 150
            implicitHeight: 20
            color: root.sColor
            radius: 2
            opacity: root.visible ? 1 : 0

            Text {
                id: monthId
                text: (new Date(root.year, root.month, 1))
                    .toLocaleDateString(Qt.locale(), "MMMM, yyyy")
                font {
                    family: "Pixelify Sans"
                    pixelSize: 15
                }
                color: root.sTxtColor
                opacity: root.visible ? 1 : 0
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }

            MouseArea {
                id: mousearea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    switch (dropdown.state) {
                        case "opened":
                            dropdown.state = "closed";
                            break;
                        case "closed":
                            dropdown.state = "opened";
                            break;
                    }
                }
            }          
            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }

        Button {
            id: nextMonth
            contentItem: Text {
                text: "arrow_forward_ios"
                font {
                    family: "Material Symbols Outlined"
                    pointSize: 9
                }
                opacity: root.visible ? 1 : 0
                color: nextMonth.down ? root.mTxtColor : root.sTxtColor
                horizontalAlignment: Text.AlignHCenter
                topPadding: 1

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
            }

            background: Rectangle {
                id: rightBtnRect
                implicitHeight: 20
                implicitWidth: 25
                bottomLeftRadius: 2
                topLeftRadius: 2
                bottomRightRadius: 8
                topRightRadius: 8
                opacity: root.visible ? 1 : 0
                color: nextMonth.down
                    ? Qt.tint(Qt.alpha(root.mColor, 1.0), "#cced752b")
                    : root.sColor
                anchors.centerIn: parent

                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }
                HoverHandler {
                    cursorShape: Qt.PointingHandCursor
                }
            }
            onClicked: {
                root.month++;
                if (root.month > 11) {
                    root.month = 0;
                    root.year++;
                }
            }
        }
    }
}
