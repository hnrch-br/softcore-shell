pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire
import qs.bar.widgets
import qs.bar
import qs.popups

Singleton {
    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource, Pipewire.nodes, Pipewire.links]
    }

    property list<PwNode> sinks: Pipewire.nodes.values.filter(node =>
        node.isSink && !node.isStream && node.audio
    )

    property PwNode defaultSink: Pipewire.defaultAudioSink

    property list<PwNode> sources: Pipewire.nodes.values.filter(node =>
        !node.isSink && !node.isStream && node.audio
    )

    property PwNode defaultSource: Pipewire.defaultAudioSource

    property real volValue: Math.floor(defaultSink?.audio?.volume * 100) ?? 0
    property bool volMuted: defaultSink?.audio?.muted ?? false
    property real micValue: Math.floor(defaultSource?.audio?.volume * 100) ?? 0
    property bool micMuted: defaultSource?.audio?.muted ?? false
}
