pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    property var entries: []
    readonly property int count: entries.length
    property bool pending: false 

    function refresh() {
        if (listProc.running) return
        listProc.running = true;
        pending = true;
    }

    function select(entry) {
        if (listProc.running) return
        copyProc.stdinEnabled = true
        copyProc.running = true 
        copyProc.write(entry.id + "\n")
        copyProc.stdinEnabled = false
    }

    function remove(entry) {
        if (delProc.running) return
        delProc.stdinEnabled = true
        delProc.running = true
        delProc.write(entry.raw + "\n")
        delProc.stdinEnabled = false
    }

    function wipe() {
        if (wipeProc.running) return
        wipeProc.running = true
    }

    property Process copyProc: Process {
        command: ["sh", "-c", "cliphist decode | wl-copy"]
        stdinEnabled: true
        onExited: running = false
    }

    property Process delProc: Process {
        command: ["cliphist", "delete"]
        onExited: {
            running = false
            root.refresh()
        }
    }

    property Process wipeProc: Process {
        command: ["cliphist", "wipe"]
        onExited: {
            running = false;
            root.refresh();
        }
    }

    property Process listProc: Process {
        command: ["sh", "-c", "cliphist list"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.entries = text
                    .split("\n")
                    .filter(l => l.length > 0)
                    .map(l => {
                        const tab = l.indexOf("\t")
                        return { id: l.slice(0, tab), preview: l.slice(tab + 1), raw: l }
                    });
                pending = false;
            }
        }
    }

    Component.onCompleted: refresh()
}
