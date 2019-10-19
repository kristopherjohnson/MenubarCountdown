//
//  StartTimerDialogController.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

class StartTimerDialogController: NSWindowController {
    @IBOutlet var startTimerDialog: NSWindow!

    var timerInterval: TimeInterval {
        let defaults = UserDefaults.standard
        let hours = defaults.integer(forKey: AppUserDefaults.timerHoursKey);
        let minutes = defaults.integer(forKey: AppUserDefaults.timerMinutesKey);
        let seconds = defaults.integer(forKey: AppUserDefaults.timerSecondsKey);
        return TimeInterval((hours * 3600) + (minutes * 60) + seconds);
    }

    func showDialog() {
        NSApp.activate(ignoringOtherApps: true)
        if !startTimerDialog.isVisible {
            startTimerDialog.center()
            startTimerDialog.makeFirstResponder(nil)
        }
        startTimerDialog.makeKeyAndOrderFront(self)
    }

    @IBAction func dismissDialog(_ sender: AnyObject) {
        if !startTimerDialog.makeFirstResponder(nil) {
            // TODO: Figure out what to do if responder didn't resign
        }
        startTimerDialog.orderOut(sender);
    }
}
