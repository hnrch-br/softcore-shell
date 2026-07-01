pragma ComponentBehavior: Bound

import Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Mpris
import Quickshell.Io

import qs.services
import qs.bar

RowLayout {
    id: root
    anchors.verticalCenter: parent.verticalCenter
    property bool isPlaying: Players.activePlayer?.isPlaying
    property string trackTitleOutput: Players.activePlayer?.trackTitle ? Players.activePlayer?.trackTitle : "none"
    property string trackArtistOutput: Players.activePlayer?.trackArtist ? Players.activePlayer?.trackArtist + ": " : "none: "
    property string trackOutput: isPlaying ? trackArtistOutput + trackTitleOutput : "no media"
    property real scrollSpeed: 80
    property real pauseDuration: 1000

    SequentialAnimation {
        id: marqueeAnim
        loops: Animation.Infinite

        PauseAnimation {
            duration: pauseDuration
        }

        NumberAnimation {
            target: trackText
            property: "x"
            from: marqueeContainer.width
            to: -trackText.width
            duration: (trackText.implicitWidth + marqueeContainer.implicitWidth) / scrollSpeed * 1000
            easing.type: Easing.Linear
        }
    }
    function restartMarquee() {
        if (!isPlaying) {
            marqueeAnim.stop();
            trackText.x = Qt.binding(() => (marqueeContainer.width - trackText.implicitWidth) / 2)        
        } else {
            marqueeAnim.start();
        }
    }

    onIsPlayingChanged: restartMarquee()

    Component.onCompleted: restartMarquee()

    Rectangle {
        id: marqueeContainer
        implicitWidth: isPlaying ? 220 : 100
        implicitHeight: 22
        color: "#ccfaebd7"
        bottomLeftRadius: 25
        topLeftRadius: 25
        bottomRightRadius: 2
        topRightRadius: 2
        clip: true

        Behavior on implicitWidth {
            NumberAnimation { duration: 200 }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            id: trackText
            text: trackOutput
            color: "#ff3d3636"
            font { family: "Pixelify Sans"; pixelSize: 16 }
        }
        Layout.rightMargin: 2
    }
}
