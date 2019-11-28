//
//  Notifications.swift
//  Menubar Countdown
//
//  Copyright © 2019 Kristopher Johnson. All rights reserved.

import Cocoa
import UserNotifications

/**
 Request appropriate authorization for displaying user notification.

 - parameters:
    - withSound: whether to request playing a sound with the notification
    - completionHandler: called with argument indicating whether authorization was granted.
 */
func requestNotificationAuthorization(withSound: Bool,
                                      completionHandler: @escaping (Bool) -> Void) {
    let authorizationOptions: UNAuthorizationOptions =
        withSound ? [.alert, .sound]
                  : [.alert]

    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.requestAuthorization(options: authorizationOptions) { (granted, error) in
        if let error = error {
            Log.debug("user notification authorization error: \(error)")
        }

        if granted {
            completionHandler(true)
        }
        else {
            Log.debug("user notification authorization was not granted")
            completionHandler(false)
        }
    }
}

/**
 Display user notification indicating timer is expired.

 - parameters:
    - withSound: whether to play a sound along with the notification

 - returns: notification ID
 */
func showTimerExpiredNotification(withSound: Bool) -> String {
    Log.debug("show timer-expired notification")

    let notificationId = UUID().uuidString

    let notificationCenter = UNUserNotificationCenter.current()

    notificationCenter.getNotificationSettings { settings in
        guard settings.authorizationStatus == .authorized else {
            Log.debug("not authorized to display notifications")
            return
        }

        if settings.alertSetting == .enabled {
            let content = UNMutableNotificationContent()
            content.title = NSLocalizedString("Menubar Countdown Expired",
                                              comment: "Notification title")
            content.body = NSLocalizedString("The countdown timer has reached 00:00:00",
                                             comment: "Notification body")

            if withSound && settings.soundSetting == .enabled {
                content.sound = UNNotificationSound.default
            }

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                                            repeats: false)

            let request = UNNotificationRequest(identifier: notificationId,
                                                content: content,
                                                trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    Log.error("notification error: \(error.localizedDescription)")
                }
            }
        }
    }

    return notificationId
}
