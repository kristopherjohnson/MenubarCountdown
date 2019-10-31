//
//  Log.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Foundation
import os.log

/**
 Application logging functions.

 All app components should call these functions instead of using `NSLog()` or `os_log()`.
 */
struct Log {

    /**
     Log an error message.

     - parameters:
        - message: Text to be logged.
        - function: Name of calling function.
        - file: Source file name of calling function.
        - line: Source line number of call location.
     */
    static func error(_ message: String,
                      function: String = #function, file: String = #file, line: Int32 = #line)
    {
        let filename = file.lastPathComponent

        let msg = "ERROR: \(message) [\(function) \(filename):\(line)]"
        os_log("%{public}@", type: .error, msg)
    }

    /**
     Log a debug-level message.

     Has no effect in a Release build.

     - parameters:
        - message: Text to be logged.
        - function: Name of calling function.
        - file: Source file name of calling function.
        - line: Source line number of call location.
     */
    static func debug(_ message: String,
                      function: String = #function, file: String = #file, line: Int32 = #line)
    {
#if DEBUG
        let filename = file.lastPathComponent

        let msg = "DEBUG: \(message) [\(function) \(filename):\(line)]"

        // Note: we log using default level rather than .debug so that the
        // messages always go into the log for a debug build
        os_log("%{public}@", msg)
#endif
    }
}
