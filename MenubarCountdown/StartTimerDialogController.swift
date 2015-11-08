//
//  StartTimerDialogController.swift
//  MenubarCountdown
//
//  Copyright © 2009, 2015 Kristopher Johnson. All rights reserved.
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

import Cocoa

class StartTimerDialogController: NSWindowController {
    @IBOutlet var startTimerDialog: NSWindow!

    var timerInterval: NSTimeInterval {
        let defaults = NSUserDefaults.standardUserDefaults()
        let hours = defaults.integerForKey(UserDefaults.TimerHoursKey);
        let minutes = defaults.integerForKey(UserDefaults.TimerMinutesKey);
        let seconds = defaults.integerForKey(UserDefaults.TimerSecondsKey);
        return NSTimeInterval((hours * 3600) + (minutes * 60) + seconds);
    }

    func showDialog() {
        NSApp.activateIgnoringOtherApps(true)
        if !startTimerDialog.visible {
            startTimerDialog.center()
            startTimerDialog.makeFirstResponder(nil)
        }
        startTimerDialog.makeKeyAndOrderFront(self)
    }

    @IBAction func dismissDialog(sender: AnyObject) {
        if !startTimerDialog.makeFirstResponder(nil) {
            // TODO: Figure out what to do if responder didn't resign
        }
        startTimerDialog.orderOut(sender);
    }
}
