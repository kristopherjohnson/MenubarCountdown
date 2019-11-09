//
//  NSApplication_Scripting.swift
//  Menubar Countdown
//
//  Copyright © 2019 Kristopher Johnson. All rights reserved.

import Cocoa

/*
 Extend `NSApplication` to support scripting commands.

 See `MenubarCountdown.sdef` for command definitions.

 See `AppDelegate_Scripting.swift` for implementations of
 scriptable properties.
*/

extension NSApplication {

    /**
     Perform the `start timer` scripting command.
     */
    @objc func startTimerViaScript(_ command: NSScriptCommand) {
        Log.debug("\"start timer\" was invoked")
        
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.startTimerViaScript(command: command)
        }
    }

    /**
     Perform the `stop timer` scripting command.
     */
    @objc func stopTimerViaScript(_ command: NSScriptCommand) {
        Log.debug("\"stop timer\" was invoked")

        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.stopTimer(command)
        }
    }

    /**
     Perform the `pause timer` scripting command.
     */
    @objc func pauseTimerViaScript(_ command: NSScriptCommand) {
        Log.debug("\"pause timer\" was invoked")

        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.pauseTimer(command)
        }
    }

    /**
     Perform the `resume timer` scripting command.
     */
    @objc func resumeTimerViaScript(_ command: NSScriptCommand) {
        Log.debug("\"resume timer\" was invoked")

        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.resumeTimer(command)
        }
    }

    /**
     Perform the `show start dialog` scripting command.
     */
    @objc func showStartDialogViaScript(_ command: NSScriptCommand) {
        Log.debug("\"show start dialog\" was invoked")

        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.showStartTimerDialog(command)
        }
    }
}
