import QtQuick
import Quickshell
import Quickshell.Io
import QtQuick.Layouts
import QtQuick.Shapes

Row {
    anchors.verticalCenter: parent.verticalCenter
    Process {
        id: cavaProc
        running: true
        command: ["sh", "-c", `
            cava -p /dev/stdin <<EOF
[general]
# Reduced to 20 for wider, smoother hills
bars = 40
framerate = 60
autosens = 1

[input]
method = pulse

[output]
method = raw
raw_target = /dev/stdout
data_format = ascii
ascii_max_range = 1000
bar_delimiter = 59

[smoothing]
monstercat = 1.5
waves = 0
gravity = 100
noise_reduction = 0.20

[eq]
1 = 1
2 = 1
3 = 1
4 = 1
5 = 1
EOF
        `]
        stdout: SplitParser {
            onRead: data => {
                let newPoints = data.split(";")
                    .map(p => parseFloat(p.trim()) / 1000)
                    .filter(p => !isNaN(p));
                let smoothFactor = 0.3; 
                if (canvas.cavaData.length === 0 || canvas.cavaData.length !== newPoints.length) {
                    canvas.cavaData = newPoints;
                } else {
                    let smoothed = [];
                    for (let i = 0; i < newPoints.length; i++) {
                        let oldVal = canvas.cavaData[i];
                        let newVal = newPoints[i];
                        smoothed.push(oldVal + (newVal - oldVal) * smoothFactor);
                    }
                    canvas.cavaData = smoothed;
                }
                
                canvas.requestPaint();
            }
        }
    }

    Canvas {
        id: canvas
        width: 16
        height: 16
        antialiasing: true
        renderTarget: Canvas.FramebufferObject
        renderStrategy: Canvas.Threaded

        property var cavaData: []
        property real baseRadius: 6
        property real amplitude: 20
        property real frequency: 8
        property int segments: 200

        onPaint: {
            var ctx = getContext("2d")
            ctx.reset()
            
            if (cavaData.length === 0)
                return

            var cx = width / 2
            var cy = height / 2
            var barCount = cavaData.length
        
            ctx.strokeStyle = "#ccfaebd7"
            ctx.lineWidth = 2
            ctx.beginPath()

        
        for (var i = 0; i <= segments; i++) {
            var theta = (i / segments) * Math.PI * 2

            // map this point's position around the circle to a fractional bar index
            var pos = (i / segments) * barCount
            var idx0 = Math.floor(pos) % barCount
            var idx1 = (idx0 + 1) % barCount
            var frac = pos - Math.floor(pos)
            var level = cavaData[idx0] * (1 - frac) + cavaData[idx1] * frac

            var r = baseRadius + level * amplitude
            var x = cx + r * Math.cos(theta)
            var y = cy + r * Math.sin(theta)

            if (i === 0)
                ctx.moveTo(x, y)
            else
                ctx.lineTo(x, y)
        }    
            ctx.closePath()
            ctx.stroke()
        }
    }
}
