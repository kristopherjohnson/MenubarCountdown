//
//  TimerExpiredAlertController.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

class TimerExpiredAlertController: NSWindowController {
    @IBOutlet var messageText: NSTextField!

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
