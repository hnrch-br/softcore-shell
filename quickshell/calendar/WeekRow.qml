import QtQuick
import Quickshell
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Controls

DayOfWeekRow {
    id: row
    locale: root.locale
    Layout.fillWidth: true
    opacity: root.visible ? 1 : 0
    spacing: 3
    delegate: Text {
        required property string shortName

        text: shortName
        font.family: "Sixtyfour"
        font.pixelSize: 7
        color: Qt.tint(root.sColor, "#54ed752b")
        leftPadding: 4
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 200
        }
    }
}
