//
//  UserDefaults.h
//  MenuTimer
//
//  Created by Kristopher Johnson on 4/4/09.
//  Copyright 2009 Capable Hands Technologies, Inc.. All rights reserved.
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

#import <Cocoa/Cocoa.h>

// Keys for this application's values in NSUserDefaults
extern NSString *UserDefaultsTimerHoursKey;                   ///< Timer hours setting
extern NSString *UserDefaultsTimerMinutesKey;                 ///< Timer minutes setting
extern NSString *UserDefaultsTimerSecondsKey;                 ///< Timer seconds setting
extern NSString *UserDefaultsPlayAlertSoundOnExpirationKey;   ///< Is alert sound enabled?
extern NSString *UserDefaultsAnnounceExpirationKey;           ///< Is speech enabled?
extern NSString *UserDefaultsAnnouncementTextKey;             ///< Text to be spoken
extern NSString *UserDefaultsShowAlertWindowOnExpirationKey;  ///< Is alert window enabled?
extern NSString *UserDefaultsShowStartDialogOnLaunchKey;      ///< Show start dialog when app launches?
extern NSString *UserDefaultsShowSeconds;                     ///< Show seconds in menubar?

/// \brief Handles registration of NSUserDefaults settings
@interface UserDefaults : NSObject
{}

/// \brief Register the default settings
///
/// Registers settings from the file UserDefaults.plist
+ (void)registerDefaults;

@end
