import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

RowLayout {
    id: root
    property var audioBars: []
    readonly property int bars: 16

    anchors.verticalCenter: parent.verticalCenter

    Process {
        id: cavaProc
        running: true
        command: ["sh", "-c", `cava -p /dev/stdin <<EOF
[general]
bars = ${root.bars}
framerate = 15
autosens = 1
[input]
method = pulse
source = $(pactl get-default-sink).monitor
[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
EOF`]
        stdout: SplitParser {
            onRead: data => {
                root.audioBars = data.split(";").map(p => {
                    const v = parseFloat(p.trim());
                    return isNaN(v) ? 0 : v / 1000;
                });
            }
        }
    }

    Rectangle {
        id: cavaRect
        clip: true
        implicitHeight: 22
        implicitWidth: 76
        color: "#ccfaebd7"
        bottomRightRadius: 25
        bottomLeftRadius: 2
        topRightRadius: 25
        topLeftRadius: 2
        Row {
            anchors.bottom: parent.bottom
            height: parent.height
            leftPadding: 4
            spacing: 2
            Repeater {
                id: cavarepeater
                model: root.bars
                Rectangle {
                    width: 2
                    height: Math.max((root.audioBars[index] ?? 0) * 22, 1)
                    color: "#ff3d3636"
                    anchors.bottom: parent.bottom
                    Behavior on height { NumberAnimation { duration: 55 } }
                    radius: 1
                }
            }
        }
    }
}
