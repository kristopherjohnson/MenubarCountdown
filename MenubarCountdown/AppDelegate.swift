//
//  AppDelegate.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019,2020 Kristopher Johnson. All rights reserved.

import Cocoa
import AudioToolbox
import UserNotifications

/**
 Application delegate which implements most of the logic of Menubar Countdown.

 From the user's point of view, the application switches between these states:

 - reset: timer is not running
 - running: timer has been started and is counting down
 - paused: timer has been started but is in a paused state
 - expired: timer has reached 00:00:00 and is waiting to be turned off

 The persistent settings of the app are managed by the UserDefaults system. 
 */
@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {

    /**
     Initial timer setting.
     */
    var timerSettingSeconds = 25 * 60

    /**
     Number of seconds remaining in countdown.
     */
    var secondsRemaining = 0

    /**
     Indicates whether timer is running.
     
     KVC compliant so it can be used to enable/disable menu items and other controls
     */
    @objc var isTimerRunning = false

    /**
     Indicates whether the timer can be paused.
    
     KVC compliant so it can be used to enable/disable menu items and other controls
    */
    @objc var canPause = false

    /**
     Indicates whether the timer can be resumed.
    
     KVC compliant so it can be used to enable/disable menu items and other controls
     */
    @objc var canResume = false

    var stopwatch: Stopwatch!

    var statusItem: NSStatusItem!

    var notificationId: String = ""

    /**
     Reference to menu loaded from MainMenu.xib.
     */
    @IBOutlet var menu: NSMenu!

    /**
     Reference to dialog loaded from StartTimerDialog.xib.
     */
    @IBOutlet var startTimerDialogController: StartTimerDialogController?

    /**
     Reference to dialog loaded from TimerExpiredAlert.xib.
     */
    @IBOutlet var timerExpiredAlertController: TimerExpiredAlertController?

    let defaults = UserDefaults.standard

    override init() {
        super.init()
        AppUserDefaults.registerUserDefaults()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        Log.debug("application did finish launching: \(notification)")

        UNUserNotificationCenter.current().delegate = self

        stopwatch.reset()

        initializeStatusItem()

        if showStartDialogOnLaunch {
            showStartTimerDialog(self)
        }

        NSApp.servicesProvider = ServicesProvider(appDelegate: self)
    }

    func applicationWillTerminate(_ notification: Notification) {
        Log.debug("application will terminate")
    }

    // MARK: Timer updating

    /**
     Determine time to the next top of second, and set a timer to call `nextSecondTimerDidFire` at that time.
     */
    func waitForNextSecond() {
        let elapsed = stopwatch.elapsedTimeInterval()
        let intervalToNextSecond = ceil(elapsed) - elapsed

        let t = Timer.scheduledTimer(timeInterval: intervalToNextSecond,
            target: self,
            selector: #selector(nextSecondTimerDidFire(_:)),
            userInfo: nil,
            repeats: false)
        t.tolerance = 0.25
    }

    /**
     Called at the top of each second.

     Updates the timer display if the timer is running.
     */
    @objc func nextSecondTimerDidFire(_ timer: Timer) {
        if isTimerRunning {
            secondsRemaining = Int(round(TimeInterval(timerSettingSeconds) - stopwatch.elapsedTimeInterval()))

            if secondsRemaining <= 0 {
                timerDidExpire()
            }
            else {
                updateStatusItemTitle(timeRemaining: secondsRemaining)
                waitForNextSecond()
            }
        }
        else {
            Log.debug("ignoring tick because timer is not running")
        }
    }

    /**
     Create `statusItem` and set its initial state.
     */
    func initializeStatusItem() {
        let statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.isVisible = true
        statusItem.behavior = [.terminationOnRemoval]
        
        statusItem.menu = menu
        statusItem.button?.wantsLayer = true
        statusItem.button?.toolTip = NSLocalizedString("Menubar Countdown",
                                                       comment: "Status Item Tooltip")
        statusItem.button?.font = NSFont.monospacedDigitSystemFont(ofSize: 0,
                                                                   weight: .regular)
        showStatusItemIcon()
    }

    /**
     Sets the text of the menu bar status item.
     */
    func updateStatusItemTitle(timeRemaining: Int) {
        var timeRemaining = timeRemaining
        
        let includeSecondsInTitle = displaySeconds
        if (!includeSecondsInTitle) {
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
        if includeSecondsInTitle {
            timeString = NSString(format: "%02d:%02d:%02d", hours, minutes, seconds) as String
        }
        else {
            timeString = NSString(format: "%02d:%02d", hours, minutes) as String
        }
        // statusItem.button?.image = nil
        statusItem.button?.title = timeString
    }

    /**
     Change the status item to an hourglass icon
     */
    func showStatusItemIcon() {
        statusItem.button?.title = ""
        if let image = NSImage(named: "HourglassIcon") {
            statusItem.button?.image = image
            statusItem.button?.imagePosition = NSControl.ImagePosition.imageLeft
        }
        else {
            Log.error("unable to load HourglassIcon")
        }
    }

    func startBlinking() {
        statusItem.button?.layer?.addBlinkAnimation()
    }

    func stopBlinking() {
        statusItem.button?.layer?.removeBlinkAnimation()
    }

    // MARK: Timer expiration

    /**
     Called when the timer reaches 00:00:00.

     Fires all of the configured notifications.
     */
    func timerDidExpire() {
        canPause = false
        canResume = false

        updateStatusItemTitle(timeRemaining: 0)

        if blinkOnExpiration {
            startBlinking()
        }

        if playAlertSoundOnExpiration {
            playAlertSound()
        }

        if speakAnnouncementOnExpiration {
            speakTimerExpiredAnnouncement(
                text: announcementText)
        }

        if showAlertWindowOnExpiration {
            showTimerExpiredAlert()
        }

        if showNotificationOnExpiration {
            self.notificationId = showTimerExpiredNotification(
                withSound: playNotificationSoundOnExpiration)
        }
    }

    /**
     Plays the alert sound.

     If configured to repeat, starts a timer to call this method again after a delay.
     */
    @objc func playAlertSound() {
        if isTimerRunning && (secondsRemaining < 1) {
            Log.debug("play alert sound")
            AudioServicesPlayAlertSound(kUserPreferredAlert);

            if repeatAlertSoundOnExpiration {
                var repeatInterval = TimeInterval(defaults.integer(forKey: AppUserDefaults.alertSoundRepeatIntervalKey))
                if repeatInterval < 1.0 {
                    repeatInterval = 1.0
                }
                Log.debug("schedule alert sound repeat \(repeatInterval)s")
                Timer.scheduledTimer(timeInterval: repeatInterval,
                    target: self,
                    selector: #selector(playAlertSound),
                    userInfo: nil,
                    repeats: false)
            }
        }
    }

    /**
     Display the alert indicating timer is expired.
     */
    func showTimerExpiredAlert() {
        Log.debug("show timer-expired alert")

        NSApp.activate(ignoringOtherApps: true)

        if timerExpiredAlertController == nil {
            TimerExpiredAlertController.load(owner: self)
            assert(timerExpiredAlertController != nil,
                   "timerExpiredAlertController outlet must be set")
        }
        timerExpiredAlertController?.showAlert()
    }


    // MARK: Menu item and button event handlers

    /**
     Display the StartTimerDialog.xib dialog.

     Called at startup, when the user chooses the Start... menu item,
     when the user clicks the Restart Countdown... button on the alert,
     or when the `show start dialog` scripting command is invoked.
     */
    @IBAction func showStartTimerDialog(_ sender: AnyObject) {
        Log.debug("show start timer dialog")

        dismissTimerExpiredAlert(sender)

        if startTimerDialogController == nil {
            StartTimerDialogController.load(owner: self)
            assert(startTimerDialogController != nil, "startTimerDialogController must be set")
        }
        startTimerDialogController?.showDialog()
    }

    /**
     Start the timer.

     Called when the user clicks the Start button in the StartTimerDialog
     or invokes the Start Countdown service.

     If user selected "Show notification", then check for authorization and
     show the notification-authorization dialog if necessary before dismissing
     the dialog and starting the timer.
     */
    @IBAction func startTimerDialogStartButtonWasClicked(_ sender: AnyObject) {
        Log.debug("start button was clicked")

        dismissTimerExpiredAlert(sender)

        defaults.synchronize()

        if showNotificationOnExpiration {
            requestNotificationAuthorization(withSound: playNotificationSoundOnExpiration) { granted in
                DispatchQueue.main.async {
                    if granted {
                        self.dismissStartTimerDialogAndStartTimer(sender)
                    }
                    else {
                        self.showNotificationOnExpiration = false
                    }
                }
            }
        }
        else {
            dismissStartTimerDialogAndStartTimer(sender)
        }
    }

    /**
     Start the timer as a result of receiving a `start timer` script command.

     This is similar to `startTimerDialogStartButtonWasClicked(_:)`, but we
     don't want to prompt the user to authorize notifications.
     */
    func startTimerViaScript(command: NSScriptCommand) {
        dismissTimerExpiredAlert(self)
        dismissStartTimerDialogAndStartTimer(self)
    }

    func dismissStartTimerDialogAndStartTimer(_ sender: AnyObject) {
        if let startTimerDialogController = startTimerDialogController {
            startTimerDialogController.dismissDialog(sender)
        }

        timerSettingSeconds = (startHours * 3600) + (startMinutes * 60) + startSeconds
        secondsRemaining = timerSettingSeconds

        isTimerRunning = true
        canPause = true
        canResume = false
        stopwatch.reset()

        updateStatusItemTitle(timeRemaining: timerSettingSeconds)

        waitForNextSecond()
    }

    /**
     Reset everything to a not-running state.

     Called when the user clicks the Stop menu item,
     clicks the OK button in the TimerExpiredAlert,
     invokes the Stop Countdown service, or invokes
     the `stop timer` scripting command.
     */
    @IBAction func stopTimer(_ sender: AnyObject) {
        Log.debug("stop timer")

        isTimerRunning = false
        canPause = false
        canResume = false

        stopBlinking()
        showStatusItemIcon()
    }

    /**
     Pause the countdown timer.

     Called when the user chooses the Pause menu item, invokes the Pause Countdown service, or invokes the `pause timer` scripting command.
     */
    @IBAction func pauseTimer(_ sender: AnyObject) {
        Log.debug("pause timer")
        if canPause {
            isTimerRunning = false
            canPause = false
            canResume = true
        }
        else {
            Log.error("can't resume in current state")
        }
    }

    /**
     Resume the countdown timer.

     Called when the user chooses the Resume menu item, invokes the Resume Countdown service, or invokes the `resume timer` scripting command.
     */
    @IBAction func resumeTimer(_ sender: AnyObject) {
        Log.debug("resume timer")
        if canResume {
            isTimerRunning = true
            canPause = true
            canResume = false

            timerSettingSeconds = secondsRemaining

            stopwatch.reset()

            updateStatusItemTitle(timeRemaining: timerSettingSeconds)

            waitForNextSecond()
        }
        else {
            Log.error("can't resume in current state")
        }
    }

    /**
     Dismiss the TimerExpiredAlert.

     Called when the user clicks the OK button in that alert,
     or whenever the StartTimerDialog is shown.
     */
    @IBAction func dismissTimerExpiredAlert(_ sender: AnyObject) {
        Log.debug("dismiss timer expired alert")
        timerExpiredAlertController?.close()
        stopTimer(sender)
    }

    /**
     Dismiss the TimerExpiredAlert and show the StartTimerDialog.

     Called when the user clicks the Restart Countdown button in the TimerExpiredAlert.
     */
    @IBAction func restartCountdownWasClicked(_ sender: AnyObject) {
        Log.debug("restart countdown was clicked")
        dismissTimerExpiredAlert(sender)
        showStartTimerDialog(sender)
    }

    /**
     Show the About box.

     Called when the user chooses the About Menubar Countdown menu item.
     */
    @IBAction func showAboutPanel(_ sender: AnyObject) {
        Log.debug("show About panel")
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }

    // MARK: UNUserNotificationCenterDelegate methods

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void)
    {
        Log.debug("calling completion handler")

        let presentationOptions: UNNotificationPresentationOptions =
            playNotificationSoundOnExpiration
                ? [.alert, .sound]
                : [.alert]

        completionHandler(presentationOptions)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // If notification is clicked, stop the timer and show the start dialog
        DispatchQueue.main.async {
            self.dismissTimerExpiredAlert(self)
            self.showStartTimerDialog(self)
        }
    }
}
