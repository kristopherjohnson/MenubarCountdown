//
//  ServicesProvider.swift
//  Menubar Countdown
//
//  Copyright © 2019 Kristopher Johnson. All rights reserved.
//

import Foundation
import Cocoa

/**
 Implements the Services menu items for the application.

 The provided services are

 - Start Countdown: show the start dialog
 - Stop Countdown: reset the timer
 - Pause Countdown: pause the timer
 - Resume Countdown: resume paused timer

 See also

 - The `NSServices` entries in `Info.plist`
 - Construction and registration of the service provider in `AppDelegate.applicationDidFinishLaunching()`

 */
@objc final class ServicesProvider: NSObject {

    private var appDelegate: AppDelegate

    init(appDelegate: AppDelegate) {
        self.appDelegate = appDelegate
    }

    /**
     Handle a Start Countdown service request.
     */
    @objc func startCountdown(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        Log.debug("Start Countdown service was requested")
        appDelegate.showStartTimerDialog(self)
    }

    /**
     Handle a Stop Countdown service request.
     */
    @objc func stopCountdown(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        Log.debug("Stop Countdown service was requested")
        appDelegate.stopTimer(self)
    }

    /**
     Handle a Pause Countdown service request.
     */
    @objc func pauseCountdown(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        Log.debug("Pause Countdown service was requested")
        appDelegate.pauseTimer(self)
    }

    /**
     Handle a Resume Countdown service request.
     */
    @objc func resumeCountdown(_ pboard: NSPasteboard, userData: String, error: NSErrorPointer) {
        Log.debug("Resume Countdown service was requested")
        appDelegate.resumeTimer(self)
    }
}
