//
//  TimerExpiredAlertController.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/7/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Cocoa

class TimerExpiredAlertController: NSWindowController {
    @IBOutlet var messageText: NSTextField!

    func showAlert() {
        if let w = self.window {
            w.makeFirstResponder(nil)
            w.level = Int(CGWindowLevelForKey(.FloatingWindowLevelKey))
            w.center()
            w.makeKeyAndOrderFront(self)
        }
        else {
            Log.error("no alert window")
        }
    }
}
