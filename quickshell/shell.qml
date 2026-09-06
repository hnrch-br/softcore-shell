//@ pragma Env QS_NO_RELOAD_POPUP=1

import Quickshell
import QtQuick

import qs.bar
import qs.services
import qs.launcher
import qs.central
import qs.clipboard
import qs.notifications

Scope {
    Bar {}
    Wrapper {}
    CentralPopup {}
    ClipWrapper {}
    //NotifPanel {}
}
