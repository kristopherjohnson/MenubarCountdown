//
//  AppDelegate_Scripting.swift
//  Menubar Countdown
//
//  Copyright © 2019 Kristopher Johnson. All rights reserved.

import Cocoa

/*
 Support for application scripting properties.

 See MenubarCountdown.sdef for definitions and descriptions
 of the scripting properties.

 Do not rename or delete any of these methods without updating
 MenubarCountdown.sdef.

 See `NSApplication_Scripting.swift` for implementations of
 scripting commands.
*/

/**
 Set of all scripting-related keys that are handled
 by the AppDelegate.
 */
fileprivate let scriptingKeys: Set = [
    "timeRemaining",
    "timerHasExpired",
    "timerIsPaused",
    "startHours",
    "startMinutes",
    "startSeconds",
    "blinkOnExpiration",
    "playAlertSoundOnExpiration",
    "repeatAlertSoundOnExpiration",
    "showAlertWindowOnExpiration",
    "showNotificationOnExpiration",
    "playNotificationSoundOnExpiration",
    "speakAnnouncementOnExpiration",
    "announcementText",
    "displaySeconds",
    "showStartDialogOnLaunch"
]

extension AppDelegate {

    /**
     Called by the application to determine if the delegate implements
     a KVO/KVC key.

     Must return `true` for all the scripting properties and commands implemented here.
     */
    func application(_ sender: NSApplication,
                     delegateHandlesKey key: String) -> Bool {
        return scriptingKeys.contains(key)
    }

    /**
     Get the `time remaining` scripting property value.
     */
    @objc dynamic var timeRemaining: Int {
        if secondsRemaining < 0 {
            return 0
        }
        return secondsRemaining
    }

    /**
     Get the `timer has expired` scripting property value.
     */
    @objc dynamic var timerHasExpired: Bool {
        secondsRemaining <= 0
    }

    /**
     Get the `timer is paused` scripting property value.
     */
    @objc dynamic var timerIsPaused: Bool {
        canResume
    }

    /**
     Get/set the `hours` scripting property.

     The value is presented to scripting as an integer, but is stored internally as a string.
     */
    @objc dynamic var startHours: Int {
        get {
            let value = defaults.string(forKey: AppUserDefaults.timerHoursKey) ?? "00"
            return Int(value) ?? 0
        }
        set {
            if newValue < 0 || newValue > 99 {
                Log.error("new hours value \(newValue) is not valid")
                return
            }

            let stringValue = NSString(format: "%02d", newValue)
            defaults.set(stringValue, forKey: AppUserDefaults.timerHoursKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `minutes` scripting property.

     The value is presented to scripting as an integer, but is stored internally as a string.
     */
    @objc dynamic var startMinutes: Int {
        get {
            let value = defaults.string(forKey: AppUserDefaults.timerMinutesKey) ?? "00"
            return Int(value) ?? 0
        }
        set {
            if newValue < 0 || newValue > 59 {
                Log.error("new minutes value \(newValue) is not valid")
                return
            }

            let stringValue = NSString(format: "%02d", newValue)
            defaults.set(stringValue, forKey: AppUserDefaults.timerMinutesKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `seconds` scripting property.

     The value is presented to scripting as an integer, but is stored internally as a string.
     */
    @objc dynamic var startSeconds: Int {
        get {
            let value = defaults.string(forKey: AppUserDefaults.timerSecondsKey) ?? "00"
            return Int(value) ?? 0
        }
        set {
            if newValue < 0 || newValue > 59 {
                Log.error("new seconds value \(newValue) is not valid")
                return
            }

            let stringValue = NSString(format: "%02d", newValue)
            defaults.set(stringValue, forKey: AppUserDefaults.timerSecondsKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `blink` scripting property.
     */
    @objc dynamic var blinkOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.blinkOnExpirationKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.blinkOnExpirationKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `play alert sound` scripting property.
     */
    @objc dynamic var playAlertSoundOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.playAlertSoundOnExpirationKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.playAlertSoundOnExpirationKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `repeat alert sound` scripting property.
     */
    @objc dynamic var repeatAlertSoundOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.repeatAlertSoundOnExpirationKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.repeatAlertSoundOnExpirationKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `show alert window` scripting property.
     */
    @objc dynamic var showAlertWindowOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.showAlertWindowOnExpirationKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.showAlertWindowOnExpirationKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `show notification` scripting property.
     */
    @objc dynamic var showNotificationOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.showNotificationOnExpirationKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.showNotificationOnExpirationKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `play notification sound` scripting property.
     */
    @objc dynamic var playNotificationSoundOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.playSoundWithNotification)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.playSoundWithNotification)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `speak announcement` scripting property.
     */
    @objc dynamic var speakAnnouncementOnExpiration: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.announceExpirationKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.announceExpirationKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `announcement text` scripting property.
     */
    @objc dynamic var announcementText: String {
        get {
            var result = defaults.string(forKey: AppUserDefaults.announcementTextKey)
            if (result == nil) || result!.isEmpty {
                result = NSLocalizedString("The Menubar Countdown timer has reached zero.",
                    comment: "Default announcement text")
            }
            return result!
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.announcementTextKey)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `display seconds` scripting property.
     */
    @objc dynamic var displaySeconds: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.showSeconds)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.showSeconds)
            defaults.synchronize()
        }
    }

    /**
     Get/set the `show settings on launch` scripting property.
     */
    @objc dynamic var showStartDialogOnLaunch: Bool {
        get {
            defaults.bool(forKey: AppUserDefaults.showStartDialogOnLaunchKey)
        }
        set {
            defaults.set(newValue, forKey: AppUserDefaults.showStartDialogOnLaunchKey)
            defaults.synchronize()
        }
    }
}
