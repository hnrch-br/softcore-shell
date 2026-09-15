pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    id: root

    property var notifications: []
    property int counter: 0
    readonly property int maxPopups: 5

    property ScriptModel notifList: ScriptModel {
        values: root.notifications
    }

    property ScriptModel popups: ScriptModel {
        values: {
            root.counter;
            const filtered = root.notifications.filter(n => {
                return n.popup
            });
            return filtered;
        }
    }

    function remove(card): void {
        root.notifications = root.notifications.filter(n => n !== card);
        root.counter++;
    }

    function clear(): void {
        root.notifications.forEach(n => {
            if (n.notification && !n.notification.Retainable.dropped) {
                n.notification.dismiss();
            }
        });
        root.notifications = [];
    }

    function toggleDnd(): void {
        root.doNotDisturb = !root.doNotDisturb;
    } 

    readonly property real timeoutLow: 4000
    readonly property real timeoutNormal: 9000
    readonly property real timeoutCritical: -1
    property bool doNotDisturb: false 

    NotificationServer {
        id: server

        keepOnReload: false
        persistenceSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        inlineReplySupported: true
        actionsSupported: true
        actionIconsSupported: true
        imageSupported: true

        onNotification: n => {
            n.tracked = true;
            const stacked = notifItem.createObject(root, {
                popup: true,
                notification: n
            });
            root.notifications = [...root.notifications, stacked];
            root.counter++;

            if (!root.doNotDisturb) {
                const max = root.notifications.filter(item => item.popup);
                if (max.length > root.maxPopups) {
                    const out = max.slice(0, max.length - root.maxPopups);
                    out.forEach(item => {
                        item.popup = false
                    });
                }
            }
        } 
    }

    component NotificationItem: QtObject {
        id: item

        required property Notification notification
        property bool popup
        property bool pause: false

        readonly property string body: notification?.body ?? ""
        readonly property string image: notification?.image ?? ""
        readonly property string summary: notification?.summary ?? ""
        readonly property string appIcon: notification?.appIcon ?? ""
        readonly property string appName: notification?.appName ?? ""
        readonly property int urgency: notification?.urgency
        readonly property list<NotificationAction> actions: notification.actions

        readonly property date currentTime: new Date()

        readonly property string timeStamp: {
            const diff = Time.date.getTime() - currentTime.getTime();
            const min = Math.floor(diff / 60000);
            const hrs = Math.floor(min / 60);
            const days = Math.floor(hrs / 24);

            if (hrs < 1 && min < 1) return "just now";
            if (hrs < 1) return `${min} min ago`;
            return `${hrs} hrs ago`;
        }

        readonly property real timeout: {
            if (notification.expireTimeout > 0) return notification.expireTimeout;
            if (item.pause) return -1;
            switch (notification.urgency) {
                case NotificationUrgency.Low: return root.timeoutLow;
                case NotificationUrgency.Normal: return root.timeoutNormal;
                case NotificationUrgency.Critical: return root.timeoutCritical;
            }
        }

        function togglePause(): void {
            item.pause = !item.pause
        }
        
        readonly property Connections retain: Connections {
            target: item.notification.Retainable

            function onDropped() {
                root.remove(item);
            }

            function onAboutToDestroy() {
                item.destroy();
            }
        }

        readonly property Connections close: Connections {
            target: item.notification

            function onClosed(reason) {
                root.remove(item);
            }
        }

        readonly property Timer timer: Timer {
            running: item.popup && item.timeout >= 0 && !item.pause
            interval: item.timeout
            onTriggered: {
                item.popup = false;
                counter++;
            }
        }
    } 

    Component {
        id: notifItem
        NotificationItem {}
    }
}
