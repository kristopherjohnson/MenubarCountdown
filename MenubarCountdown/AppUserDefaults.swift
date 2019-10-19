//
//  UserDefaults.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.
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
