//
//  UserDefaults.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/7/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Foundation

struct UserDefaults {
    static let TimerHoursKey                   = "TimerHours"
    static let TimerMinutesKey                 = "TimerMinutes"
    static let TimerSecondsKey                 = "TimerSeconds"
    static let BlinkOnExpirationKey            = "BlinkOnExpiration"
    static let PlayAlertSoundOnExpirationKey   = "PlayAlertSoundOnExpiration"
    static let RepeatAlertSoundOnExpirationKey = "RepeatAlertSoundOnExpiration"
    static let AlertSoundRepeatIntervalKey     = "AlertSoundRepeatInterval"
    static let AnnounceExpirationKey           = "AnnounceExpiration"
    static let AnnouncementTextKey             = "AnnouncementText"
    static let ShowAlertWindowOnExpirationKey  = "ShowAlertWindowOnExpiration"
    static let ShowStartDialogOnLaunchKey      = "ShowStartDialogOnLaunch"
    static let ShowSeconds                     = "ShowSeconds"

    static func registerUserDefaults() {
        if let plistPath = NSBundle.mainBundle().pathForResource("UserDefaults", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: plistPath) as? [String : AnyObject] {
                NSUserDefaults.standardUserDefaults().registerDefaults(dict)
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
