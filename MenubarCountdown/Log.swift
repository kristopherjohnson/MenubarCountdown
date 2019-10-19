//
//  Log.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Foundation

struct Log {

    /// Log an error message
    static func error(_ message: String,
                      function: String = #function, file: String = #file, line: Int32 = #line)
    {
        let filename = file.lastPathComponent

        let msg = "ERROR: \(message) [\(function) \(filename):\(line)]"
        NSLog("%@", msg);

        DTraceErrorMessage(message, function, filename, line)
    }

    /// Log a debug-level message
    static func debug(_ message: String,
                      function: String = #function, file: String = #file, line: Int32 = #line)
    {
        #if DEBUG
            let filename = file.lastPathComponent
            
            let msg = "DEBUG: \(message) [\(function) \(filename):\(line)]"
            NSLog("%@", msg);

            DTraceDebugMessage(message, function, filename, line)
        #endif
    }
}
