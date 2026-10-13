pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Pipewire

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

    function setSinkVolume(v) {
        if (defaultSink?.ready)
        return defaultSink.audio.volume = v
    }
    
    function setSourceVolume(m) {
        if (defaultSource?.ready)
        return defaultSource.audio.volume = m
    }

    property real sinkVolume: defaultSink?.audio.volume ?? 0
    property bool sinkMuted: defaultSink?.audio?.muted ?? false
    property real sourceVolume: defaultSource?.audio.volume ?? 0
    property bool sourceMuted: defaultSource?.audio?.muted ?? false
}
