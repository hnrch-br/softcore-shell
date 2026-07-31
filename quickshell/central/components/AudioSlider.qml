import QtQuick
import QtQuick.Controls

Slider {
    id: volSlider
    readonly property color backColor: "#b18c61"
    readonly property color handleColor: "#faebd7"
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    orientation: Qt.Horizontal
    from: 0
    to: 1.0
    snapMode: Slider.SnapAlways
    stepSize: 0.05
    
    background: Rectangle {
        id: volRect
        implicitWidth: volSlider.parent.width - 15
        implicitHeight: 8
        width: volSlider.availableWidth
        height: implicitHeight
        radius: 4
        color: volSlider.backColor
        x: volSlider.leftPadding
        y: volSlider.topPadding 
            + volSlider.availableHeight / 2 
            - height / 2
    }

    handle: Rectangle {
        implicitWidth: 8
        implicitHeight: 32
        radius: 4
        x: volSlider.leftPadding 
            + volSlider.visualPosition 
            * (volSlider.availableWidth - width)
        y: volSlider.topPadding 
            + volSlider.availableHeight / 2 
            - height / 2
        color: volSlider.handleColor
    }
}
