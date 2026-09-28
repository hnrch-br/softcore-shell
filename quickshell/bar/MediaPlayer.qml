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
    id: mediaRoot

    Layout.alignment: Qt.AlignVCenter

    readonly property bool isPlaying: Players.activePlayer?.isPlaying ?? false
    readonly property string trackTitleOutput: Players.activePlayer?.trackTitle ? Players.activePlayer?.trackTitle : "none"
    readonly property string trackArtistOutput: Players.activePlayer?.trackArtist ? `${Players.activePlayer?.trackArtist}: ` : "none: "
    readonly property string trackOutput: trackArtistOutput + trackTitleOutput
    readonly property real scrollSpeed: 80
    readonly property real pauseDuration: 1000

    SequentialAnimation {
        id: marqueeAnim
        loops: Animation.Infinite

        PauseAnimation {
            duration: mediaRoot.pauseDuration
        }

        NumberAnimation {
            target: trackText
            property: "x"
            from: 0
            to: -(trackText.contentWidth + marqueeContainer.implicitWidth)
            duration: (trackText.contentWidth + marqueeContainer.implicitWidth) / scrollSpeed * 1000
            easing.type: Easing.Linear
        }

        NumberAnimation {
            target: trackText
            property: "x"
            from: marqueeContainer.implicitWidth
            to: 0
            duration: (marqueeContainer.implicitWidth) / scrollSpeed * 1000
            easing.type: Easing.Linear
        }

        PauseAnimation {
            duration: 5 * mediaRoot.pauseDuration
        }
    }

    function restartMarquee() {
        if (!isPlaying) {
            marqueeAnim.stop();
            trackText.opacity = 0;
            noTrackText.opacity = 1;
        } else {
            noTrackText.opacity = 0;
            trackText.opacity = 1;
            trackText.x = 0;
            marqueeAnim.start();
        }
    }

    onIsPlayingChanged: restartMarquee()

    Component.onCompleted: restartMarquee()

    Rectangle {
        id: marqueeContainer
        implicitWidth: isPlaying ? 220 : 100
        implicitHeight: 22
        color: root.sColor
        bottomLeftRadius: 4
        topLeftRadius: 4
        bottomRightRadius: 2
        topRightRadius: 2
        clip: true

        Behavior on implicitWidth {
            NumberAnimation { duration: 200 }
        }

        Text {
            anchors.fill: parent
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
            id: noTrackText
            text: "none"
            color: "#ff3d3636"
            font { family: "Pixelify Sans"; pixelSize: 16 }

            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }
        }

        Text {
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Qt.AlignLeft
            id: trackText
            text: trackOutput
            color: "#ff3d3636"
            font { family: "Pixelify Sans"; pixelSize: 16 }

            x: 0
            opacity: 0

            Behavior on opacity {
                NumberAnimation { duration: 150; easing.type: Easing.OutQuad }
            }
        }
    }
}
