//
//  UserDefaults.m
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

#import "UserDefaults.h"


NSString *UserDefaultsTimerHoursKey = @"TimerHours";
NSString *UserDefaultsTimerMinutesKey = @"TimerMinutes";
NSString *UserDefaultsTimerSecondsKey = @"TimerSeconds";
NSString *UserDefaultsPlayAlertSoundOnExpirationKey = @"PlayAlertSoundOnExpiration";
NSString *UserDefaultsAnnounceExpirationKey = @"AnnounceExpiration";
NSString *UserDefaultsAnnouncementTextKey = @"AnnouncementText";
NSString *UserDefaultsShowAlertWindowOnExpirationKey = @"ShowAlertWindowOnExpiration";
NSString *UserDefaultsShowStartDialogOnLaunchKey = @"ShowStartDialogOnLaunch";
NSString *UserDefaultsShowSeconds = @"ShowSeconds";


@implementation UserDefaults

+ (void)registerDefaults {
    NSLog(@"UserDefaults registerDefaults");
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"UserDefaults"
                           ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dict];
}

@end


