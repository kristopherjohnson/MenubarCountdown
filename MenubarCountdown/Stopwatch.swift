//
//  Stopwatch.swift
//  MenubarCountdown
//
//  Copyright © 2009, 2015 Kristopher Johnson. All rights reserved.
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

import Cocoa

/// Timekeeping object
///
/// A Stopwatch computes the absolute time interval between
/// the current time and the last call to `reset` (or `init`).

@objc class Stopwatch: NSObject {
    private var startTime: TimeInterval

    /// Initialize with current time as start point
    override init() {
        startTime = CACurrentMediaTime()
    }

    /// Reset start point to current time
    func reset() {
        startTime = CACurrentMediaTime()
    }

    /// Calculate elapsed time since initialization or last call to reset()
    func elapsedTimeInterval() -> TimeInterval {
        return CACurrentMediaTime() - startTime
    }
}
