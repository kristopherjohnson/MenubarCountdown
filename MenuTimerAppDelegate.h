//
//  MenuTimerAppDelegate.h
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

#import <Cocoa/Cocoa.h>

@class Stopwatch;
@class StartTimerDialogController;
@class TimerExpiredAlertController;
@class GrowlHandler;

/// \brief Application delegate
@interface MenuTimerAppDelegate : NSObject {
    int timerSettingSeconds;   ///< Timer setting
    int secondsRemaining;      ///< Number of seconds remaining

    BOOL timerIsRunning;       ///< Instance variable for \c timerIsRunning property
    BOOL canResume;            ///< Instance variable for \c canResume property

    NSStatusItem *statusItem;  ///< Reference to NSStatusItem

    IBOutlet NSMenu *menu;                                             ///< Outlet for main menu
    IBOutlet Stopwatch *stopwatch;                                     ///< Outlet for Stopwatch
    IBOutlet StartTimerDialogController *startTimerDialogController;   ///< Outlet for StartTimerDialogController
    IBOutlet TimerExpiredAlertController *timerExpiredAlertController; ///< Outlet for TimerExpiredAlertController
    IBOutlet GrowlHandler *growl;                                      ///< Outlet for GrowlHandler
}

/// \brief Indicates whether the timer is running
///
/// This property is bound to the Stop menu item's Enabled property
@property (nonatomic) BOOL timerIsRunning;

/// \brief Indicates whether the timer can be resumed
///
/// This property is bound to the Resume menu item's Enabled property
@property (nonatomic) BOOL canResume;

/// \brief Handle the "About..." menu item
- (IBAction)showAboutPanel:(id)sender;

/// \brief Start the timer
///
/// Displays the StartTimerDialogController's window
- (IBAction)startTimer:(id)sender;

/// \brief Stop the timer
- (IBAction)stopTimer:(id)sender;

/// \brief Resume the timer
- (IBAction)resumeTimer:(id)sender;

/// \brief Invoked when the Start button on the StartTimerDialogController's window is clicked
- (IBAction)startTimerDialogStartButtonWasClicked:(id)sender;

/// \brief Invoked when OK button is clicked in timer-expired alert window
- (IBAction)dismissTimerExpiredAlert:(id)sender;

/// \brief Invoked when the "Restart Countdown..." button is clicked
- (IBAction)restartCountdownWasClicked:(id)sender;

@end
