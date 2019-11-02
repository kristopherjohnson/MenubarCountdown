#!/usr/bin/swift

/**
 This script shows the Menubar Countdown settings dialog, as if the user chose
 the "Start…" menu item.

 To run this script from the command line, do this:

     /usr/bin/swift start_menubar_countdown.swift

 or make it executable and then just run it directly, like this:

     chmod +x start_menubar_countdown.swift
     ./start_menubar_countdown.swift
 */

import AppKit
import Darwin

let success = NSPerformService("Start Menubar Countdown", nil)

exit(success ? 0 : 1)
