pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Bluetooth

Singleton {
    id: root

    readonly property BluetoothAdapter defaultAdapter: Bluetooth.defaultAdapter
    readonly property bool enabled: root.defaultAdapter?.enabled ?? false
    readonly property bool scanning: root.defaultAdapter?.discovering ?? false
    readonly property bool discoverable: root.defaultAdapter?.discoverable ?? false

    function toggleEnabled(): void {
        root.defaultAdapter.enabled = !root.defaultAdapter.enabled
    }

    function toggleScanning(): void {
        root.defaultAdapter.discovering = !root.defaultAdapter.discovering
    }

    function toggleDiscoverable(): void {
        root.defaultAdapter.discoverable = !root.defaultAdapter.discoverable
    }

    readonly property string deviceName: root.defaultAdapter.enabled ? (root.activeDevice?.name ?? "No device") : "Off"
    readonly property string btStatus: root.defaultAdapter.enabled ? "On" : "Off"
    readonly property string scanningStatus: root.defaultAdapter.discovering ? "Yes" : "No"
    readonly property string discoverStatus: root.defaultAdapter.discoverable ? "Yes" : "No"
    readonly property list<BluetoothDevice> pairedDevices: root.defaultAdapter?.devices?.values.filter(d => d.paired) ?? []
    readonly property list<BluetoothDevice> devices: root.defaultAdapter?.devices?.values.filter(d => !d.paired) ?? []
    readonly property BluetoothDevice activeDevice: root.pairedDevices.find(d => d.connected) ?? null

    readonly property string btIcon: {
        if (!defaultAdapter.enabled)
        return "bluetooth_disabled";
        if (defaultAdapter.enabled)
        return "bluetooth";
        if (activeDevice)
        return "bluetooth_connected";
    }

    readonly property string scanningIcon: {
        if (defaultAdapter.discovering)
        return "search";
        if (!defaultAdapter.discovering)
        return "search_off"
    }
}
