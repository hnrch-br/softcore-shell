pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.UPower

Singleton {
    id: root
    
    readonly property var dev: UPower.displayDevice
    readonly property var bat: UPower.devices.values.filter(d => d.isLaptopBattery)
    
    readonly property bool isLaptop: root.dev.isLaptopBattery
    readonly property bool onBat: UPower.onBattery

    readonly property real perc: isLaptop ? root.dev.percentage : 0

    readonly property bool hasPerf: PowerProfiles.hasPerformanceProfile
    readonly property string profileState: {
        switch (PowerProfiles.profile) {
            case PowerProfile.Balanced: return "Balanced";
            case PowerProfile.Performance: return "Performance";
            case PowerProfile.PowerSaver: return "Power Saver";
            default: return "";
        }
    }
    function profile(): void {
        switch (PowerProfiles.profile) {
            case PowerProfile.Balanced:
                PowerProfiles.profile = PowerProfile.Performance;
                break;
            case PowerProfile.Performance:
                PowerProfiles.profile = PowerProfile.PowerSaver;
                break;
            case PowerProfile.PowerSaver:
                PowerProfiles.profile = PowerProfile.Balanced;
                break;
        }
    }
}
