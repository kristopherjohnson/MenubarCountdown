//
//  Stopwatch.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/6/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Cocoa

/// Timekeeping object
///
/// A Stopwatch computes the absolute time interval between
/// the current time and the last call to `reset` (or `init`).

@objc class Stopwatch: NSObject {
    private var startTime: NSTimeInterval

    /// Initialize with current time as start point
    override init() {
        startTime = CACurrentMediaTime()
    }

    /// Reset start point to current time
    func reset() {
        startTime = CACurrentMediaTime()
    }

    /// Calculate elapsed time since initialization or last call to reset()
    func elapsedTimeInterval() -> NSTimeInterval {
        return CACurrentMediaTime() - startTime
    }
}
