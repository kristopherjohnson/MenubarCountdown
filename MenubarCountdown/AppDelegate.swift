//
//  AppDelegate.swift
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
import AudioToolbox

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    /// Initial timer setting
    var timerSettingSeconds = 25 * 60

    /// Number of seconds remaining
    var secondsRemaining = 0

    /// Indicates whether timer is running
    var isTimerRunning = false

    /// Indicates whether the timer can be paused
    var canPause = false

    /// Indicates whether the timer can be resumed
    var canResume = false

    var stopwatch = Stopwatch()

    var statusItem: NSStatusItem!

    var statusItemView: StatusItemView!

    @IBOutlet var menu: NSMenu!

    @IBOutlet var startTimerDialogController: StartTimerDialogController!

    @IBOutlet var timerExpiredAlertController: TimerExpiredAlertController!

    override init() {
        UserDefaults.registerUserDefaults()
    }

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        Log.debug("application did finish launching")

        stopwatch.reset()

        let statusBar = NSStatusBar.systemStatusBar()
        statusItem = statusBar.statusItemWithLength(NSVariableStatusItemLength)

        statusItemView = StatusItemView()
        statusItemView.statusItem = statusItem
        statusItemView.menu = menu
        statusItemView.toolTip = NSLocalizedString("Menubar Countdown", comment: "Status Item Tooltip")
        statusItem.view = statusItemView

        updateStatusItemTitle(0)

        if NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.ShowStartDialogOnLaunchKey) {
            showStartTimerDialog(self)
        }
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        Log.debug("application will terminate")
    }

    // MARK: Timer updating

    func waitForNextSecond() {
        let elapsed = stopwatch.elapsedTimeInterval()
        let intervalToNextSecond = ceil(elapsed) - elapsed

        NSTimer.scheduledTimerWithTimeInterval(intervalToNextSecond,
            target: self,
            selector: Selector("nextSecondTimerDidFire:"),
            userInfo: nil,
            repeats: false)
    }

    func nextSecondTimerDidFire(timer: NSTimer) {
        if isTimerRunning {
            secondsRemaining = Int(round(NSTimeInterval(timerSettingSeconds) - stopwatch.elapsedTimeInterval()))
            DTraceTimerTick(Int32(secondsRemaining))

            if secondsRemaining <= 0 {
                timerDidExpire()
            }
            else {
                updateStatusItemTitle(secondsRemaining)
                waitForNextSecond()
            }
        }
        else {
            Log.debug("ignoring tick because timer is not running")
        }
    }

    func updateStatusItemTitle(var timeRemaining: Int) {
        let showSeconds = NSUserDefaults.standardUserDefaults().boolForKey(UserDefaults.ShowSeconds)
        if (!showSeconds) {
            // Round timeRemaining up to the next minute
            let minutes = Double(timeRemaining) / 60.0
            timeRemaining = Int(ceil(minutes)) * 60
        }

        let hours = timeRemaining / 3600
        timeRemaining %= 3600
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60

        // TODO: Use localized time-formatting function
        var timeString: String
        if showSeconds {
            timeString = NSString(format: "%02d:%02d:%02d", hours, minutes, seconds) as String
        }
        else {
            timeString = NSString(format: "%02d:%02d", hours, minutes) as String
        }
        statusItemView.title = timeString
    }

    // MARK: Timer expiration

    func timerDidExpire() {
        DTraceTimerExpired()

        canPause = false
        canResume = false

        updateStatusItemTitle(0)

        let defaults = NSUserDefaults.standardUserDefaults()

        if defaults.boolForKey(UserDefaults.BlinkOnExpirationKey) {
            statusItemView.isTitleBlinking = true
        }

        if defaults.boolForKey(UserDefaults.PlayAlertSoundOnExpirationKey) {
            playAlertSound()
        }

        if defaults.boolForKey(UserDefaults.AnnounceExpirationKey) {
            announceTimerExpired()
        }

        if defaults.boolForKey(UserDefaults.ShowAlertWindowOnExpirationKey) {
            showTimerExpiredAlert()
        }
    }

    func playAlertSound() {
        if isTimerRunning && (secondsRemaining < 1) {
            Log.debug("play alert sound")
            AudioServicesPlayAlertSound(kUserPreferredAlert);

            let defaults = NSUserDefaults.standardUserDefaults()
            if defaults.boolForKey(UserDefaults.RepeatAlertSoundOnExpirationKey) {
                var repeatInterval = NSTimeInterval(defaults.integerForKey(UserDefaults.AlertSoundRepeatIntervalKey))
                if repeatInterval < 1.0 {
                    repeatInterval = 1.0
                }
                Log.debug("schedule alert sound repeat \(repeatInterval)s")
                NSTimer.scheduledTimerWithTimeInterval(repeatInterval,
                    target: self,
                    selector: Selector("playAlertSound"),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }

    func announceTimerExpired() {
        let text = announcementText()
        Log.debug("speaking announcement \"\(text)\"")
        if let synth = NSSpeechSynthesizer(voice: nil) {
            synth.startSpeakingString(text)
        }
        else {
            Log.error("unable to initialize speech synthesizer")
        }
    }

    func announcementText() -> String {
        var result = NSUserDefaults.standardUserDefaults().stringForKey(UserDefaults.AnnouncementTextKey)
        if (result == nil) || result!.isEmpty {
            result = NSLocalizedString("The Menubar Countdown timer has reached zero.",
                comment: "Default announcement text")
        }
        return result!
    }

    func showTimerExpiredAlert() {
        Log.debug("show timer-expired alert")

        NSApp.activateIgnoringOtherApps(true)

        if timerExpiredAlertController == nil {
            NSBundle.mainBundle().loadNibNamed("TimerExpiredAlert",
                owner: self,
                topLevelObjects: nil)
            assert(timerExpiredAlertController != nil, "timerExpiredAlertController outlet must be set")
        }
        timerExpiredAlertController.showAlert()
    }

    // MARK: Menu item and button event handlers

    @IBAction func showStartTimerDialog(sender: AnyObject) {
        Log.debug("show start timer dialog")

        dismissTimerExpiredAlert(sender)

        if startTimerDialogController == nil {
            NSBundle.mainBundle().loadNibNamed("StartTimerDialog",
                owner: self,
                topLevelObjects: nil)
            assert(startTimerDialogController != nil, "startTimerDialogController must be set")
        }
        startTimerDialogController.showDialog()
    }

    @IBAction func startTimerDialogStartButtonWasClicked(sender: AnyObject) {
        Log.debug("start button was clicked")

        dismissTimerExpiredAlert(sender)

        startTimerDialogController.dismissDialog(sender)

        NSUserDefaults.standardUserDefaults().synchronize()

        timerSettingSeconds = Int(startTimerDialogController.timerInterval)
        DTraceStartTimer(Int32(timerSettingSeconds))

        isTimerRunning = true
        canPause = true
        canResume = true
        stopwatch.reset()

        updateStatusItemTitle(timerSettingSeconds)
        statusItemView.showTitle()

        waitForNextSecond()
    }

    @IBAction func stopTimer(sender: AnyObject) {
        Log.debug("stop timer")
        DTraceStartTimer(Int32(secondsRemaining))

        isTimerRunning = false
        canPause = false
        canResume = false

        statusItemView.isTitleBlinking = false
        statusItemView.showIcon()
    }

    @IBAction func pauseTimer(sender: AnyObject) {
        Log.debug("pause timer")
        DTracePauseTimer(Int32(secondsRemaining))

        isTimerRunning = false
        canPause = false
        canResume = true
    }

    @IBAction func resumeTimer(sender: AnyObject) {
        Log.debug("resume timer")
        DTraceResumeTimer(Int32(secondsRemaining))

        isTimerRunning = true
        canPause = false
        canResume = false

        timerSettingSeconds = secondsRemaining

        stopwatch.reset()

        updateStatusItemTitle(timerSettingSeconds)
        statusItemView.showTitle()

        waitForNextSecond()
    }

    @IBAction func dismissTimerExpiredAlert(sender: AnyObject) {
        Log.debug("dismiss timer expired alert")
        if timerExpiredAlertController != nil {
            timerExpiredAlertController.close()
        }
        stopTimer(sender)
    }

    @IBAction func restartCountdownWasClicked(sender: AnyObject) {
        Log.debug("restart countdown was clicked")
        dismissTimerExpiredAlert(sender)
        showStartTimerDialog(sender)
    }

    @IBAction func showAboutPanel(sender: AnyObject) {
        Log.debug("show About panel")
        NSApp.activateIgnoringOtherApps(true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }
}
