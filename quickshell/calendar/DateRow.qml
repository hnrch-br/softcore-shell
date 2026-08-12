import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

RowLayout {
    Layout.alignment: Qt.AlignHCenter
    Layout.topMargin: 10
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
            color: lastMonth.down ? Qt.tint(Qt.alpha(root.mColor, 1.0), "#cced752b") : root.sColor
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
        implicitWidth: 125
        implicitHeight: 20
        color: root.sColor
        radius: 2
        opacity: root.visible ? 1 : 0
        Text {
            id: monthId
            text: (new Date(root.year, root.month, 1)).toLocaleDateString(Qt.locale(), "MMMM, yyyy")
            font {
                family: "Pixelify Sans"
                pixelSize: 15
            }
            color: root.sTxtColor
            opacity: root.visible ? 1 : 0
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
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
            color: nextMonth.down ? Qt.tint(Qt.alpha(root.mColor, 1.0), "#cced752b") : root.sColor
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
