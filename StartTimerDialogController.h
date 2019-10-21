//
//  StartTimerDialogController.h
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

#import <Cocoa/Cocoa.h>

/// \brief Displays the timer settings dialog
///
/// The controls in the dialog window are bound to
/// properties in the shared NSUserDefaultsController,
/// so other objects access the values via that
/// object rather than by querying this controller or
/// its window.
@interface StartTimerDialogController : NSWindowController {
    IBOutlet NSWindow *startTimerDialog;  ///< Outlet for the dialog window
}

/// \brief Display the dialog window
- (void)showDialog;

/// \brief Hide the dialog window
- (IBAction)dismissDialog:(id)sender;

/// \brief Return the time interval specified in the dialog
- (NSTimeInterval)timerInterval;

@end
