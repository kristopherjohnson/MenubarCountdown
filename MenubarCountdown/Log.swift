//
//  Log.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/7/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Foundation

struct Log {

    /// Log an error message
    static func error(message: String,
        function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__)
    {
        let filename = file.lastPathComponent

        let msg = "ERROR: \(message) [\(function) \(filename):\(line)]"
        NSLog("%@", msg);

        DTraceErrorMessage(message, function, filename, line)
    }

    /// Log a debug-level message
    static func debug(message: String,
        function: String = __FUNCTION__, file: String = __FILE__, line: Int32 = __LINE__)
    {
        #if DEBUG
            let filename = file.lastPathComponent
            
            let msg = "DEBUG: \(message) [\(function) \(filename):\(line)]"
            NSLog("%@", msg);

            DTraceDebugMessage(message, function, filename, line)
        #endif
    }
}
