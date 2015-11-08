//
//  UserDefaults.swift
//  MenubarCountdown
//
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//
//  This file is part of Menubar Countdown.
//
//  Menubar Countdown is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Menubar Countdown is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Menubar Countdown.  If not, see <http://www.gnu.org/licenses/>.
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
