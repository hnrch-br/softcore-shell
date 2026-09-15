//@ pragma Env QT_SCALE_FACTOR=1
//@ pragma UseQApplication
//@ pragma DefaultEnv QS_DROP_EXPENSIVE_FONTS=1
//@ pragma DefaultEnv QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma Env QS_NO_RELOAD_POPUP=1
//@ pragma IconTheme Gruvbox-Plus-Dark
//@ pragma Env QS_ICON_THEME = Gruvbox-Plus-Dark
import Quickshell
import QtQuick

import qs.bar
import qs.services
import qs.launcher
import qs.central
import qs.clipboard
import qs.notifications

ShellRoot {
    Bar {}
    Wrapper {}
    CentralPopup {}
    ClipWrapper {}
    NotifWrapper {}
}
