//
//  StartTimerDialogController.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

/**
 Window controller for the "Menubar Countdown Settings" dialog that is used to start the countdown.

 Also see StartTimerDialog.xib.
 */
final class StartTimerDialogController: NSWindowController {
    @IBOutlet var startTimerDialog: NSWindow!

    /**
     Load the dialog from the nib.

     The `owner` argument must be an object with a `startTimerDialogController`
     property, which will be set to an instance of this class.
     */
    static func load(owner: NSObject) {
        Bundle.main.loadNibNamed("StartTimerDialog",
            owner: owner,
            topLevelObjects: nil)
    }

    /**
     Display the dialog and bring it to the front.
     */
    func showDialog() {
        NSApp.activate(ignoringOtherApps: true)
        if !startTimerDialog.isVisible {
            startTimerDialog.center()
            startTimerDialog.makeFirstResponder(nil)
        }
        startTimerDialog.makeKeyAndOrderFront(self)
    }

    /**
     Hide the dialog.
     */
    @IBAction func dismissDialog(_ sender: AnyObject) {
        if !startTimerDialog.makeFirstResponder(nil) {
            Log.error("first responder didn't resign")
        }
        startTimerDialog.orderOut(sender);
    }
}
