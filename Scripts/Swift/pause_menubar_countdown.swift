#!/usr/bin/swift

/**
 This script pauses the Menubar Countdown settings dialog, as if the user chose
 the "Pause" menu item.

 To run this script from the command line, do this:

     /usr/bin/swift pause_menubar_countdown.swift

 or make it executable and then just run it directly, like this:

     chmod +x pause_menubar_countdown.swift
     ./pause_menubar_countdown.swift
 */

import AppKit
import Darwin

let success = NSPerformService("Pause Menubar Countdown", nil)

exit(success ? 0 : 1)
