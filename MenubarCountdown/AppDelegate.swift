//
//  AppDelegate.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

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
class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {

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

    override init() {
        super.init()
        AppUserDefaults.registerUserDefaults()
    }

    func applicationDidFinishLaunching(_ notification: Notification) {
        Log.debug("application did finish launching")

        stopwatch.reset()

        initializeStatusItem()

        if UserDefaults.standard.bool(forKey: AppUserDefaults.showStartDialogOnLaunchKey) {
            showStartTimerDialog(self)
        }

        UNUserNotificationCenter.current().delegate = self
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

        Timer.scheduledTimer(timeInterval: intervalToNextSecond,
            target: self,
            selector: #selector(nextSecondTimerDidFire(_:)),
            userInfo: nil,
            repeats: false)
    }

    /**
     Called at the top of each second.

     Updates the timer display if the timer is running.
     */
    @objc func nextSecondTimerDidFire(_ timer: Timer) {
        if isTimerRunning {
            secondsRemaining = Int(round(TimeInterval(timerSettingSeconds) - stopwatch.elapsedTimeInterval()))
            DTraceTimerTick(Int32(secondsRemaining))

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
        
        let showSeconds = UserDefaults.standard.bool(forKey: AppUserDefaults.showSeconds)
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
        statusItem.button?.title = timeString
    }

    /**
     Change the status item to an hourglass icon
     */
    func showStatusItemIcon() {
        statusItem.button?.title = "⌛️"
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
        DTraceTimerExpired()

        canPause = false
        canResume = false

        updateStatusItemTitle(timeRemaining: 0)

        let defaults = UserDefaults.standard

        if defaults.bool(forKey: AppUserDefaults.blinkOnExpirationKey) {
            startBlinking()
        }

        if defaults.bool(forKey: AppUserDefaults.playAlertSoundOnExpirationKey) {
            playAlertSound()
        }

        if defaults.bool(forKey: AppUserDefaults.announceExpirationKey) {
            announceTimerExpired()
        }

        if defaults.bool(forKey: AppUserDefaults.showAlertWindowOnExpirationKey) {
            showTimerExpiredAlert()
        }

        if defaults.bool(forKey: AppUserDefaults.showNotificationOnExpirationKey) {
            showTimerExpiredNotification()
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

            let defaults = UserDefaults.standard
            if defaults.bool(forKey: AppUserDefaults.repeatAlertSoundOnExpirationKey) {
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
     Speak the configured announcement.
     */
    func announceTimerExpired() {
        let text = announcementText()
        Log.debug("speaking announcement \"\(text)\"")
        if let synth = NSSpeechSynthesizer(voice: nil) {
            synth.startSpeaking(text)
        }
        else {
            Log.error("unable to initialize speech synthesizer")
        }
    }

    /**
     Returns the configured announcement text, or a default value if not configured.
     */
    func announcementText() -> String {
        var result = UserDefaults.standard.string(forKey: AppUserDefaults.announcementTextKey)
        if (result == nil) || result!.isEmpty {
            result = NSLocalizedString("The Menubar Countdown timer has reached zero.",
                comment: "Default announcement text")
        }
        return result!
    }

    /**
     Display the alert indicating timer is expired.
     */
    func showTimerExpiredAlert() {
        Log.debug("show timer-expired alert")

        NSApp.activate(ignoringOtherApps: true)

        if timerExpiredAlertController == nil {
            TimerExpiredAlertController.load(owner: self)
            assert(timerExpiredAlertController != nil, "timerExpiredAlertController outlet must be set")
        }
        timerExpiredAlertController?.showAlert()
    }

    /**
     Display notification indicating timer is expired.
     */
    func showTimerExpiredNotification() {
        Log.debug("show timer-expired notification")

        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.getNotificationSettings { settings in
            guard settings.authorizationStatus == .authorized else {
                Log.debug("not authorized to display notifications")
                return
            }

            if settings.alertSetting == .enabled {
                let content = UNMutableNotificationContent()
                content.title = NSLocalizedString("Menubar Countdown Expired",
                                                  comment: "Notification title")
                content.body = NSLocalizedString("The countdown timer has reached 00:00:00",
                                                 comment: "Notification body")

                if UserDefaults.standard.bool(forKey: AppUserDefaults.playSoundWithNotification) &&
                    settings.soundSetting == .enabled
                {
                    content.sound = UNNotificationSound.default
                }

                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                                                repeats: false)

                self.notificationId = UUID().uuidString

                let request = UNNotificationRequest(identifier: self.notificationId,
                                                    content: content,
                                                    trigger: trigger)

                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        Log.error("notification error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // MARK: Menu item and button event handlers

    /**
     Display the StartTimerDialog.xib dialog.

     Called at startup, when the user chooses the Start... menu item,
     or when the user clicks the Restart Countdown... button on the alert.
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

     Called when the user clicks the Start button in the StartTimerDialog.

     If user selected "Show notification", then check for authorization and
     show the notification-authorization dialog if necessary before dismissing
     the dialog and starting the timer.
     */
    @IBAction func startTimerDialogStartButtonWasClicked(_ sender: AnyObject) {
        Log.debug("start button was clicked")

        dismissTimerExpiredAlert(sender)

        let defaults = UserDefaults.standard
        defaults.synchronize()

        if defaults.bool(forKey: AppUserDefaults.showNotificationOnExpirationKey) {
            let authorizationOptions: UNAuthorizationOptions =
                defaults.bool(forKey: AppUserDefaults.playSoundWithNotification)
                    ? [.alert, .sound] : [.alert]
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.requestAuthorization(options: authorizationOptions) { (granted, error) in
                if let error = error {
                    Log.debug("user notification authorization error: \(error)")
                }

                if !granted {
                    Log.debug("user notification authorization was not granted")
                    UserDefaults.standard.set(false,
                                              forKey: AppUserDefaults.showNotificationOnExpirationKey)
                }

                DispatchQueue.main.async {
                    self.dismissStartTimerDialogAndStartTimer(sender)
                }
            }
        }
        else {
            dismissStartTimerDialogAndStartTimer(sender)
        }
    }

    func dismissStartTimerDialogAndStartTimer(_ sender: AnyObject) {
        if let startTimerDialogController = startTimerDialogController {
            startTimerDialogController.dismissDialog(sender)

            timerSettingSeconds = Int(startTimerDialogController.timerInterval)
            DTraceStartTimer(Int32(timerSettingSeconds))

            isTimerRunning = true
            canPause = true
            canResume = true
            stopwatch.reset()

            updateStatusItemTitle(timeRemaining: timerSettingSeconds)

            waitForNextSecond()
        }
    }

    /**
     Reset everything to a not-running state.

     Called when the user clicks the Stop menu item or
     clicks the OK button in the TimerExpiredAlert.
     */
    @IBAction func stopTimer(_ sender: AnyObject) {
        Log.debug("stop timer")
        DTraceStartTimer(Int32(secondsRemaining))

        isTimerRunning = false
        canPause = false
        canResume = false

        stopBlinking()
        showStatusItemIcon()
    }

    /**
     Pause the countdown timer.

     Called when the user chooses the Pause menu item.
     */
    @IBAction func pauseTimer(_ sender: AnyObject) {
        Log.debug("pause timer")
        DTracePauseTimer(Int32(secondsRemaining))

        isTimerRunning = false
        canPause = false
        canResume = true
    }

    /**
     Resume the countdown timer.

     Called when the user chooses the Resume menu item.
     */
    @IBAction func resumeTimer(_ sender: AnyObject) {
        Log.debug("resume timer")
        DTraceResumeTimer(Int32(secondsRemaining))

        isTimerRunning = true
        canPause = false
        canResume = false

        timerSettingSeconds = secondsRemaining

        stopwatch.reset()

        updateStatusItemTitle(timeRemaining: timerSettingSeconds)

        waitForNextSecond()
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
            UserDefaults.standard.bool(forKey: AppUserDefaults.playSoundWithNotification)
                ? [.alert, .sound] : [.alert]
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
