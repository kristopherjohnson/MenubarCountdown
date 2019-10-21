//
//  StartTimerDialogController.m
//  MenuTimer
//
//  Created by Kristopher Johnson on 3/29/09.
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

#import "StartTimerDialogController.h"
#import "UserDefaults.h"


@implementation StartTimerDialogController

- (void)showDialog {
    [NSApp activateIgnoringOtherApps:YES];
    if (![startTimerDialog isVisible]) {
        [startTimerDialog center];
        [startTimerDialog makeFirstResponder:nil];
    }
    [startTimerDialog makeKeyAndOrderFront:self];
}


- (IBAction)dismissDialog:(id)sender {
    if (![startTimerDialog makeFirstResponder:nil]) {
        // TODO: Figure out what to do if responder didn't resign
    }
    [startTimerDialog orderOut:sender];
}


- (NSTimeInterval)timerInterval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int timerHours = [defaults integerForKey:UserDefaultsTimerHoursKey];
    int timerMinutes = [defaults integerForKey:UserDefaultsTimerMinutesKey];
    int timerSeconds = [defaults integerForKey:UserDefaultsTimerSecondsKey];
    return (timerHours * 3600) + (timerMinutes * 60) + timerSeconds;
}


- (void)dealloc {
    [startTimerDialog release];
    [super dealloc];
}


@end
