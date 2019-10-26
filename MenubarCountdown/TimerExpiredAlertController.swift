//
//  TimerExpiredAlertController.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

/**
 Alert displayed when the timer reaches 00:00:00.

 Also see TimerExpiredAlert.xib.
 */
class TimerExpiredAlertController: NSWindowController {
    @IBOutlet var messageText: NSTextField!

    /**
     Load the alert from the NIB.

     The `owner` must be an object with a `timerExpiredAlertController` property,
     which will be set to an instance of this class.
     */
    static func load(owner: NSObject) {
        Bundle.main.loadNibNamed("TimerExpiredAlert",
            owner: owner,
            topLevelObjects: nil)
    }

    /**
     Show the alert and bring it to the front.
     */
    func showAlert() {
        if let w = self.window {
            w.makeFirstResponder(nil)
            w.level = .floating
            w.center()
            w.makeKeyAndOrderFront(self)
        }
        else {
            Log.error("no alert window")
        }
    }
}
