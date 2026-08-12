pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property var list: []
    property var decodeQueue: []
    property bool decoding: false

    Process {
        id: listProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                var entries = [];
                var lines = this.text.trim().split('\n');
                for (var i = 0; i < lines.length; i++) {
                    var line = lines[i].trim();
                    if (line.length === 0)
                        continue;
                    var tab = line.indexOf('\t');
                    if (tab === -1)
                        continue;
                    var id = parseInt(line.substring(0, tab));
                    var content = line.substring(tab + 1);
                    var img = content.match(/\[\[ binary data (.+?) ([a-z]+) (.+?) \]\]/);
                    var isImg = img !== null;

                    entries.push({
                        id: id,
                        content: isImg ? `${img[2]}, ${img[1]}, ${img[3]}` : content,
                        imgType: isImg ? img[2] : "",
                        imgSize: isImg ? img[1] : "",
                        imgDimensions: isImg ? img[3] : "",
                        previewSource: ""
                    });
                }
                root.list = entries;
                var queue = [];
                for (var j = 0; j < entries.length; j++) {
                    if (entries[j].imgType !== "")
                        queue.push({ id: entries[j].id, mimeType: entries[j].imgType });
                }
                root.decodeQueue = queue;
                root.processQueue();
            }
        }
    }

    Process {
        id: decodeProc
        stdout: StdioCollector {
            onStreamFinished: {
                var current = root.decodeQueue[0];
                root.decodeQueue = root.decodeQueue.slice(1);
                root.applyPreview(current.id, current.mimeType, this.text.trim());
                root.decoding = false;
                root.processQueue();
            }
        }
    }

    function processQueue() {
        if (root.decoding || root.decodeQueue.length === 0)
            return;
        root.decoding = true;
        var next = root.decodeQueue[0];
        decodeProc.command = ["bash", "-c", "cliphist decode " + next.id + " | base64 -w 0"];
        decodeProc.running = true;
    }

    function applyPreview(id, mimeType, base64Data) {
        root.list = root.list.map(function (entry) {
            if (entry.id !== id)
                return entry;
            var copy = Object.assign({}, entry);
            copy.previewSource = "data:image/" + mimeType + ";base64," + base64Data;
            return copy;
        });
    }

    function copyEntry(id) {
        Quickshell.execDetached(["sh", "-c", `cliphist decode ${id} | wl-copy`])
    }
 
    Component.onCompleted: listProc.running = true
}
