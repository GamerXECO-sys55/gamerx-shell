// GamerX OS · audio service via PipeWire
pragma Singleton
pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import Quickshell.Services.Pipewire

Singleton {
    id: root

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    function setVolume(value: real): void {
        if (sink?.audio) sink.audio.volume = Math.max(0, Math.min(1, value))
    }
    function setMuted(m: bool): void {
        if (sink?.audio) sink.audio.muted = m
    }
    function toggleMuted(): void {
        if (sink?.audio) sink.audio.muted = !sink.audio.muted
    }

    PwObjectTracker { objects: [Pipewire.defaultAudioSink].filter(o => !!o) }
}
