//
//  Stopwatch.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

/**
 Timekeeping object

 A Stopwatch computes the absolute time interval between
 the current time and the last call to `reset` (or `init`).
 */
@objc class Stopwatch: NSObject {
    
    /**
     Start of timing interval
     */
    private var startTime: TimeInterval

    /**
     Initialize with current time as start point.
     */
    override init() {
        startTime = CACurrentMediaTime()
        super.init()
    }

    /**
     Reset start point to current time.
     */
    func reset() {
        startTime = CACurrentMediaTime()
    }

    /**
     Calculate elapsed time since initialization or last call to `reset`.
     */
    func elapsedTimeInterval() -> TimeInterval {
        return CACurrentMediaTime() - startTime
    }
}
