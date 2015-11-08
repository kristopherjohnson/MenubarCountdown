//
//  StartTimerDialogController.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/7/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
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
