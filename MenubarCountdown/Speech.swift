//
//  Speech.swift
//  Menubar Countdown
//
//  Copyright © 2019 Kristopher Johnson. All rights reserved.

import Cocoa

/**
 Speak the configured timer-expired announcement.

 - parameters:
    - text: announcement to be spoken
 */
func speakTimerExpiredAnnouncement(text: String) {
    Log.debug("speaking announcement \"\(text)\"")
    if let synth = NSSpeechSynthesizer(voice: nil) {
        synth.startSpeaking(text)
    }
    else {
        Log.error("unable to initialize speech synthesizer")
    }
}
