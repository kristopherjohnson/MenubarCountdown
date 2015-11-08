//
//  Stopwatch.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/6/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Cocoa

/// Calculates elapsed time
public struct Stopwatch {
    private var startTime: NSTimeInterval

    /// Initialize with current time as start point
    public init() {
        startTime = CACurrentMediaTime()
    }

    /// Reset start point to current time
    public mutating func reset() {
        startTime = CACurrentMediaTime()
    }

    /// Calculate elapsed time since initialization or last call to reset()
    public func elapsedTimeInterval() -> NSTimeInterval {
        return CACurrentMediaTime() - startTime
    }

    /// Calculate elapsed nanoseconds since initialization or last call to reset()
    func elapsedNanoseconds() -> UInt64 {
        return UInt64(elapsedTimeInterval() * 1e9);
    }
}
