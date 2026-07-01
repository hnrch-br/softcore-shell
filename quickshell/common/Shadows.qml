import QtQuick
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

DropShadow {
    id: root

    color: "black"
    radius: 5
    spread: 1
    samples: 6
    horizontalOffset: 2
    verticalOffset: 2
    cached: true
}

