import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls
ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.topMargin: 15

    MonthGrid {
        id: grid 
        month: root.month
        year: root.year
        spacing: 3
        locale: root.locale
        Layout.fillWidth: true
        Layout.fillHeight: true

        delegate: Rectangle {
            id: gridRect
            implicitWidth: 30
            implicitHeight: 30

            required property var model

            property bool isCurrentMonth: model.month === root.month
        
            property bool isToday: {
                model.date.toDateString() === root.currentDate.toDateString()
            }
        
            property bool isSelected: { 
                model.date.toDateString() === root.selectedDate.toDateString()
            }

            color: isSelected
                ? Qt.tint(root.sColor, "#cced752b") 
                : isToday
                ? Qt.tint(root.sColor, "#af895f")
                : "transparent"
            radius: 4

            MouseArea {
                anchors.fill: gridRect
                cursorShape: Qt.PointingHandCursor
                hoverEnabled: true
                onClicked: root.selectedDate = gridRect.model.date
            }

            Text {
                id: monthDays
                anchors.centerIn: gridRect
                text: gridRect.model.day
                font {
                    family: "Bytesized"
                    pixelSize: 16
                }
                opacity: root.visible ? 1 : 0
                color: gridRect.isSelected 
                    ? Qt.darker(root.sTxtColor, 0.9) 
                    : gridRect.isToday 
                    ? Qt.darker(root.sTxtColor, 0.9) 
                    : gridRect.isCurrentMonth 
                    ? Qt.darker(root.mTxtColor, 1) 
                    : Qt.darker(root.mTxtColor, 0.35)
                font.bold: parent.isToday ? true : false
                leftPadding: 3.1
            }
        }
    }
}
