pragma Singleton

import Quickshell
import Quickshell.Networking
import QtQuick

Singleton {
    id: root
    
    readonly property var wirelessDevice: Networking.devices.values.find(d => d.type === DeviceType.Wifi) ?? null
    readonly property var wiredDevice: Networking.devices.values.find(d => d.type === DeviceType.Wired) ?? null
    
    readonly property var activeNetwork: wirelessDevice?.networks.values.find(n => n.connected) ?? null
    readonly property var networksRaw: wirelessDevice?.networks?.values ?? []
    readonly property bool wirelessConnected: root.wirelessDevice?.connected ?? false
    readonly property bool wiredConnected: root.wiredDevice?.connected ?? false
        
    readonly property real signalStrength: root.activeNetwork?.signalStrength ?? 0
    readonly property string ssid: root.activeNetwork?.name ?? ""

    readonly property string networkLabel: root.wirelessConnected ? root.ssid : "Ethernet"

    readonly property int stateUnknown: ConnectionState.Unknown
    readonly property int stateConnecting: ConnectionState.Connecting
    readonly property int stateConnected: ConnectionState.Connected
    readonly property int stateDisconnecting: ConnectionState.Disconnecting
    readonly property int stateDisconnected: ConnectionState.Disconnected

    readonly property var securityWpaPsk: WifiSecurityType.WpaPsk
    readonly property var securityWpa2Psk: WifiSecurityType.Wpa2Psk
    readonly property var securitySae: WifiSecurityType.Sae
    readonly property var failReasonNoSecrets: ConnectionFailReason.NoSecrets

    function toggleNet(): void {
        if (root.wirelessConnected)
        return root.wirelessDevice.wifiEnabled = !root.wirelessDevice.wifiEnabled;
    }

    function toggleScan(on): void {
        if (!wirelessDevice) return;
        wirelessDevice.scannerEnabled = on;
    }

    readonly property var netIcon: {
        if (root.wiredConnected) {
            return "conversion_path"
        } else {
            return "conversion_path_off"
        }
        if (root.wirelessConnected) {
            const s = root.signalStrength;
            if (s >= 0.8) return "wifi";
            if (s >= 0.4) return "wifi_2_bar";
            if (s >= 0.2) return "wifi_1_bar";
            return "android_wifi_3_bar_off";
        }
        return "block";
    }

    readonly property var networks: {
        const seen = {};
        const out = [];
        for (let i = 0; i < networksRaw.length; i++) {
            const n = networksRaw[i];
            if (!n || !n.name) continue;
            const prev = seen[n.name];
            if (!prev || n.signalStrength > prev.signalStrength) {
                seen[n.name] = n;
            }
        }
        for (const k in seen) out.push(seen[k]);
        out.sort(function(a,b) {
            const rank = function(n) {
                if (n.connected) return 0;
                if (n.known) return 1;
                return 2;
            };
            const ra = rank(a), rb = rank(b);
            if (ra !== rb) return ra - rb;
            return (b.signalStrength ?? 0) - (a.signalStrength ?? 0);
        });
        return out;
    }
}
