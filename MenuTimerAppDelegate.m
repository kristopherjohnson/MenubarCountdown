//
//  MenuTimerAppDelegate.m
//  MenuTimer
//
//  Created by Kristopher Johnson on 3/19/09.
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

#import "MenuTimerAppDelegate.h"
#import "Stopwatch.h"
#import "StartTimerDialogController.h"
#import "TimerExpiredAlertController.h"
#import "UserDefaults.h"
#import <AudioToolbox/AudioServices.h>
#import "GrowlHandler.h"


@interface MenuTimerAppDelegate (private)
+ (void)setupUserDefaults;
- (void)nextSecondTimerDidFire:(NSTimer*)timer;
- (void)updateStatusItemTitle:(int)timeRemaining;
- (void)timerDidExpire;
- (void)announceTimerExpired;
- (NSString*)announcementText;
- (void)showTimerExpiredAlert;
@end


@implementation MenuTimerAppDelegate

@synthesize timerIsRunning;
@synthesize canResume;


+ (void)initialize {
    [UserDefaults registerDefaults];
}


- (void)dealloc {
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];

    [growl release];
    [timerExpiredAlertController release];
    [startTimerDialogController release];
    [stopwatch release];
    [statusItem release];
    [menu release];
    [super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    timerSettingSeconds = 25 * 60;
    secondsRemaining = timerSettingSeconds;
    self.timerIsRunning = NO;

    [stopwatch reset];

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem retain];
    [self updateStatusItemTitle:0];
    [statusItem setMenu:menu];
    [statusItem setHighlightMode:YES];
    [statusItem setToolTip:NSLocalizedString(@"Menubar Countdown",
                                             @"Status Item Tooltip")];

    // Call startTimer: whenever Growl notification is clicked
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(startTimer:)
               name:GrowlHandlerTimerExpiredNotificationWasClicked
             object:nil];
    [growl connectToGrowl];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:UserDefaultsShowStartDialogOnLaunchKey]) {
        [self startTimer:self];
    }
}


- (void)updateStatusItemTitle:(int)timeRemaining {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    bool showSeconds = [defaults boolForKey:UserDefaultsShowSeconds];

    if (!showSeconds) {
        // Round timeRemaining up to the next minute
        double minutes = (double)timeRemaining / 60.0;
        timeRemaining = (int)ceil(minutes) * 60;
    }

    int hours = timeRemaining / 3600;
    timeRemaining %= 3600;
    int minutes = timeRemaining / 60;
    int seconds = timeRemaining % 60;

    // TODO: Use localized time-formatting function
    NSString* timeString;
    if (showSeconds) {
        timeString = [NSString stringWithFormat:@"%02d:%02d:%02d",
                      hours, minutes, seconds];
    }
    else {
        timeString = [NSString stringWithFormat:@"%02d:%02d",
                      hours, minutes];
    }

    [statusItem setTitle:timeString];
}


- (void)waitForNextSecond {
    NSTimeInterval elapsed = [stopwatch elapsedTimeInterval];
    double intervalToNextSecond = ceil(elapsed) - elapsed;

    [NSTimer scheduledTimerWithTimeInterval:intervalToNextSecond
                                     target:self
                                   selector:@selector(nextSecondTimerDidFire:)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)nextSecondTimerDidFire:(NSTimer*)timer {
    if (self.timerIsRunning) {
        secondsRemaining = nearbyint(timerSettingSeconds - [stopwatch elapsedTimeInterval]);
        if (secondsRemaining <= 0) {
            [self timerDidExpire];
        }
        else {
            [self updateStatusItemTitle:secondsRemaining];
            [self waitForNextSecond];
        }
    }
}


- (IBAction)startTimer:(id)sender {
    [self dismissTimerExpiredAlert:sender];

    if (!startTimerDialogController) {
        [NSBundle loadNibNamed:@"StartTimerDialog" owner:self];
    }
    [startTimerDialogController showDialog];
}


- (IBAction)startTimerDialogStartButtonWasClicked:(id)sender {
    [self dismissTimerExpiredAlert:sender];

    [startTimerDialogController dismissDialog:sender];

    [[NSUserDefaults standardUserDefaults] synchronize];

    timerSettingSeconds = (int)[startTimerDialogController timerInterval];
    self.timerIsRunning = YES;
    self.canResume = NO;
    [stopwatch reset];
    [self updateStatusItemTitle:timerSettingSeconds];
    [self waitForNextSecond];
}


- (IBAction)stopTimer:(id)sender {
    self.timerIsRunning = NO;
    if (secondsRemaining > 0) {
        self.canResume = YES;
    }
}


- (IBAction)resumeTimer:(id)sender {
    if (secondsRemaining < 1) {
        return;
    }
    timerSettingSeconds = secondsRemaining;
    self.timerIsRunning = YES;
    self.canResume = NO;
    [stopwatch reset];
    [self updateStatusItemTitle:timerSettingSeconds];
    [self waitForNextSecond];
}


- (void)timerDidExpire {
    self.canResume = NO;
    self.timerIsRunning = NO;
    [self updateStatusItemTitle:0];

    [growl notifyTimerExpired:[self announcementText]];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:UserDefaultsPlayAlertSoundOnExpirationKey]) {
        AudioServicesPlayAlertSound(kUserPreferredAlert);
    }

    if ([defaults boolForKey:UserDefaultsAnnounceExpirationKey]) {
        [self announceTimerExpired];
    }

    if ([defaults boolForKey:UserDefaultsShowAlertWindowOnExpirationKey]) {
        [self showTimerExpiredAlert];
    }
}


- (void)announceTimerExpired {
    NSSpeechSynthesizer *synth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    [synth startSpeakingString:[self announcementText]];
    [synth release];
}


- (NSString *)announcementText {
    NSString *result = [[NSUserDefaults standardUserDefaults] stringForKey:UserDefaultsAnnouncementTextKey];
    if ([result length] < 1) {
        result = NSLocalizedString(@"The Menubar Countdown timer has reached zero.",
                                   @"Default announcement text");
    }
    return result;
}

    
- (void)showTimerExpiredAlert {
    [NSApp activateIgnoringOtherApps:YES];

    if (!timerExpiredAlertController) {
        [NSBundle loadNibNamed:@"TimerExpiredAlert" owner:self];
    }
    [timerExpiredAlertController showAlert];
}


- (IBAction)dismissTimerExpiredAlert:(id)sender {
    [timerExpiredAlertController close];
}


- (IBAction)restartCountdownWasClicked:(id)sender {
    [self dismissTimerExpiredAlert:sender];
    [self startTimer:sender];
}


- (IBAction)showAboutPanel:(id)sender {
    [NSApp activateIgnoringOtherApps:YES];
    [NSApp orderFrontStandardAboutPanel:sender];
}


@end
