pragma ComponentBehavior: Bound
pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Io

Singleton {
    id: root

    property ListModel list: ListModel {}
    property int selectedIndex: -1

    Process {
        id: listProc
        command: ["cliphist", "list"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.list.clear();
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
                    var img = content.match(/\[\[ binary match (.+?) ([a-z]+) (.+?) \]\]/);
                    var isImg = img !== null;

                    root.list.append({
                        id: id,
                        content: content,
                        imgType: isImg ? img[2] : "",
                        imgSize: isImg ? img[1] : "",
                        imgDimensions: isImg ? img[3] : "",
                        previewSource: ""
                    });
                }
            }
        }
    }

    Component.onCompleted: listProc.running = true
}
