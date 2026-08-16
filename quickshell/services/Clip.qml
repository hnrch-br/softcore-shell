pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property var list: []
    property var decode: []
    property bool decoding: false

    Process {
        id: watchProc
        command: ["sh", "-c", "wl-paste --watch echo x"]
        running: true
        stdout: SplitParser {
            onRead: line => root.refresh()
        }
    }

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
                var q = [];
                for (var j = 0; j < entries.length; j++) {
                    if (entries[j].imgType !== "")
                        q.push({
                            id: entries[j].id,
                            mimeType: entries[j].imgType
                        });
                }
                root.decode = q;
                root.process();
            }
        }
    }

    Process {
        id: decodeProc
        stdout: StdioCollector {
            onStreamFinished: {
                var cur = root.decode[0];
                root.decode = root.decode.slice(1);
                root.apply(cur.id, cur.mimeType, this.text.trim());
                root.decoding = false;
                root.process();
            }
        }
    }

    function process() {
        if (root.decoding || root.decode.length === 0)
            return;
        root.decoding = true;
        var next = root.decode[0];
        decodeProc.command = ["sh", "-c", `cliphist decode ${next.id} | base64 -w 0`];
        decodeProc.running = true;
    }

    function apply(id, mimeType, base64Data) {
        root.list = root.list.map(function (entry) {
            if (entry.id !== id)
                return entry;
            var cp = Object.assign({}, entry);
            cp.previewSource = `data:image/${mimeType};base64,${base64Data}`;
            return cp;
        });
    }

    function copyEntry(id) {
        Quickshell.execDetached(["sh", "-c", `cliphist decode ${id} | wl-copy`]);
    }

    function refresh() {
        root.decode = [];
        root.decoding = false;
        listProc.running = true;
    }

    Component.onCompleted: listProc.running = true
}
