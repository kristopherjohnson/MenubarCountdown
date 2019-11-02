#!/usr/bin/swift

/**
 This script stops the Menubar Countdown timer, as if the user chose the
 "Stop" menu item.

 To run this script from the command line, do this:

     /usr/bin/swift stop_menubar_countdown.swift

 or make it executable and then just run it directly, like this:

     chmod +x stop_menubar_countdown.swift
     ./stop_menubar_countdown.swift
 */

import AppKit
import Darwin

let success = NSPerformService("Stop Menubar Countdown", nil)

exit(success ? 0 : 1)
