//
//  AppUserDefaults.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Foundation

/**
 Defines UserDefaults keys used by this application.

 The resource `UserDefaults.plist` holds default values for these keys.
 */
struct AppUserDefaults {
    static let timerHoursKey                   = "TimerHours"
    static let timerMinutesKey                 = "TimerMinutes"
    static let timerSecondsKey                 = "TimerSeconds"
    static let blinkOnExpirationKey            = "BlinkOnExpiration"
    static let playAlertSoundOnExpirationKey   = "PlayAlertSoundOnExpiration"
    static let repeatAlertSoundOnExpirationKey = "RepeatAlertSoundOnExpiration"
    static let alertSoundRepeatIntervalKey     = "AlertSoundRepeatInterval"
    static let announceExpirationKey           = "AnnounceExpiration"
    static let announcementTextKey             = "AnnouncementText"
    static let showAlertWindowOnExpirationKey  = "ShowAlertWindowOnExpiration"
    static let showStartDialogOnLaunchKey      = "ShowStartDialogOnLaunch"
    static let showSeconds                     = "ShowSeconds"

    /**
     Adds default values to the registration domain.

     Default values are read from the `UserDefaults.plist` resource.
     */
    static func registerUserDefaults() {
        if let plistPath = Bundle.main.path(forResource: "UserDefaults", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: plistPath) as? [String : Any] {
                UserDefaults.standard.register(defaults: dict)
            }
            else {
                Log.error("unable to load UserDefaults.plist")
            }
        }
        else {
            Log.error("unable to find UserDefaults.plist")
        }
    }
}
