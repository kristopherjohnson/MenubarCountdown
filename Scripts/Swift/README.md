This directory contains automation scripts that can be used to control Menubar
Countdown from a command line or from utilities that can run scripts.

These scripts require version 2.1 or higher of Menubar Countdown.

The scripts are written in Swift.  The `/usr/bin/swift` interpreter is available
on the versions of macOS supported by Menubar Countdown 2.1 and higher.  You can
pass the scripts to the Swift interpreter on the command line like this:

    /usr/bin/swift start_menubar_countdown.swift

or you can mark the scripts executable and run them directly like this:

    chmod +x start_menubar_countdown.swift
    ./start_menubar_countdown.swift
