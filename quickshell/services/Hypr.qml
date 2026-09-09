pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    id: root
    
    readonly property int minWorkspaces: 5
    readonly property int focusedId: Hyprland.focusedWorkspace?.id ?? -1

    readonly property int workspaceCount: root.workspaces.length

    readonly property var workspaces: {
        try {
            const value = Hyprland.workspaces.values
                .filter(workspace => workspace.id >= 0)
                .sort((a, b) => a.id - b.id);

            const base = Array.from({ length: root.minWorkspaces }, (_, i) => {
                const id = i + 1;
                return value.find(w => w.id === id) ?? {
                    id
                };
            });

            const filtering = value.filter(w => w.id > root.minWorkspaces);

            return [...base, ...filtering];
        } catch (e) {
            return [];
        }
    }

    function focusWorkspace(id) {
        Hyprland.dispatch("hl.dsp.focus({ workspace = " + Number(id) + " })");
    }
}
