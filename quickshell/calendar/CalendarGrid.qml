import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

MonthGrid {
    id: grid
    Layout.fillWidth: true
    Layout.fillHeight: true
    month: root.month
    year: root.year
    spacing: 3
    locale: root.locale
    opacity: root.visible ? 1 : 0
    Layout.topMargin: 7

    delegate: Rectangle {
        id: gridRect
        implicitWidth: 30
        implicitHeight: 30

        required property var model
        property bool isCurrentMonth: model.month === root.month
        property bool isToday: model.date.toDateString() === root.currentDate.toDateString()
        property bool isSelected: model.date.toDateString() === root.selectedDate.toDateString()

        color: isSelected ? Qt.tint(root.sColor, "#cced752b") : isToday ? Qt.tint(root.sColor, "#af895f") : "transparent"
        radius: 4

        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            hoverEnabled: true
            onClicked: root.selectedDate = gridRect.model.date
        }

        Text {
            id: monthDays
            anchors.centerIn: gridRect
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: gridRect.model.day
            font.family: "Bytesized"
            opacity: root.visible ? 1 : 0
            font.pixelSize: 16
            color: gridRect.isSelected 
                ? Qt.darker(root.sTxtColor, 0.9) 
                : gridRect.isToday 
                ? Qt.darker(root.sTxtColor, 0.9) 
                : gridRect.isCurrentMonth 
                ? Qt.darker(root.mTxtColor, 1) 
                : Qt.darker(root.mTxtColor, 0.35)
            font.bold: parent.isToday ? true : false
            leftPadding: 3.1

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }
}
