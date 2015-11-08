//
//  Log.swift
//  MenubarCountdown
//
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//
//  This file is part of Menubar Countdown.
//
//  Menubar Countdown is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Menubar Countdown is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Menubar Countdown.  If not, see <http://www.gnu.org/licenses/>.
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
