#!/usr/bin/swift

/**
 This script resumes the Menubar Countdown timer, as if the user chose the
 "Resume" menu item.

 To run this script from the command line, do this:

     /usr/bin/swift resume_menubar_countdown.swift

 or make it executable and then just run it directly, like this:

     chmod +x resume_menubar_countdown.swift
     ./resume_menubar_countdown.swift
 */

import AppKit
import Darwin

let success = NSPerformService("Resume Menubar Countdown", nil)

exit(success ? 0 : 1)
