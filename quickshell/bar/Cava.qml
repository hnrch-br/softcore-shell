import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Shapes

RowLayout {
    id: cavaRoot
    property list<int> values: Array(cavaRoot.bars)
    readonly property int bars: 16 

    Layout.alignment: Qt.AlignVCenter

    Process {
        id: cavaProc
        running: true
        command: ["sh", "-c", `cava -p /dev/stdin <<EOF
[general]
bars=${cavaRoot.bars}
framerate=60
autosens=1
[output]
channels=stereo
method=raw
raw_target=/dev/stdout
data_format=ascii
ascii_max_range=100
[smoothing]
noise_reduction=11
EOF`]
        stdout: SplitParser {
            onRead: data => {
                cavaRoot.values = data.slice(0, -1).split(";").map(v => parseInt(v, 10));
            }
        }
    }

    Rectangle {
        id: cavaRect
        clip: true
        implicitHeight: 22
        implicitWidth: 76
        color: root.sColor
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
                model: cavaRoot.bars
                Rectangle {
                    required property int index
                    width: 2
                    height: {
                        const value = cavaRoot.values[index] || 0;
                        return Math.max(1, value * 0.58);
                    }
                    color: "#ff3d3636"
                    anchors.bottom: parent.bottom
                    Behavior on height { NumberAnimation { duration: 55 } }
                    radius: 1
                }
            }
        }
    }
}
