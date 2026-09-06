pragma Singleton

import Quickshell
import QtQuick
import Quickshell.Services.Notifications

Singleton {
    id: root

    property list<Notification> stack: []
    property int counter: 0

    property real timeoutLow: 5000
    property real timeoutNormal: 10000
    property real timeoutCritical: -1

    property ScriptModel data: ScriptModel {
        values: root.stack
    }

    property ScriptModel popups: ScriptModel {
        values: {
            root.counter;
            const filtered = root.stack.filter(n => {
                return n.popup;
            });
            return filtered;
        }
    }

    function removeNotification(obj): void {
        root.stack = root.stack.filter(n => n !== obj);
        root.counter++;
    }

    function clearAll(): void {
        root.stack.forEach(n => {
            if (n.notification && !n.notification.Retainable.dropped) {
                n.notification.dismiss();
            }
        });
        root.stack = [];
    }

    NotificationServer {
        id: server

        bodySupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodyHyperlinksSupported: true
        inlineReplySupported: true
        actionsSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: n =>  {
            n.tracked = true;
            const newNotif = nComponent.createObject(root, {
                popup: true,
                notification: n
            });

            root.stack = [ ...root.stack, newNotif ];
            root.counter++;
        }
    }

    component Notif: QtObject {
        id: notif

        property bool popup
        readonly property date time: new Date()

        readonly property string timeStr: {
            const sub = Time.date.getTime() - time.getTime();
            const min = Math.floot(sub / 60000);
            const hrs = Math.floor(m / 60);
            if (hrs < 1 && min < 1) return "now";
            if (hrs < 1) return `${min} min`
            return `${hrs} hrs`
        }

        required property Notification notification

        readonly property string summary: notification.summary
        readonly property string body: notification.body
        readonly property string appIcon: notification.appIcon
        readonly property string appName: notification.appName
        readonly property string image: notification.image
        readonly property int urgency: notification.urgency
        readonly property list<NotificationAction> actions: notification.actions
        readonly property real timeout: {
            if (notif.notification.expireTimeout > 0)
                return notif.notification.expireTimeout;
            switch (notif.notification.urgency) {
                case NotificationUrgency.Low: return root.timeoutLow
                case NotificationUrgency.Normal: return root.timeoutNormal
                case NotificationUrgency.Critical: return root.timeoutCritical
            }
        }

        readonly property Timer timer: Timer {
            running: notif.popup
            interval: notif.timeout
            onTriggered: {
                notif.popup = false;
                root.counter++;
            }
        }

        readonly property Connections retainConn: Connections {
            target: notif.notification.Retainable

            function onDropped(): void {
                root.removeNotification(notif);
            }

            function onAboutToDestroy(): void {
                notif.destroy();
            }
        }

        readonly property Connections closeConn: Connections {
            target: notif.notification

            function onClosed(reason) {
                root.removeNotification(notif);
            }
        }

        function dismiss(): void {
            notif.notification.dismiss();
        }
    }

    Component {
        id: nComponent
        Notif {}
    }
}
