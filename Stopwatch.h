/*
 *  Stopwatch.h
 *  MenuTimer
 *
 *  Created by Kristopher Johnson on 3/26/09.
 *  Copyright 2009 Capable Hands Technologies, Inc.. All rights reserved.
 *
 *  This file is part of Menubar Countdown.
 *
 *  Menubar Countdown is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Menubar Countdown is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Menubar Countdown.  If not, see <http://www.gnu.org/licenses/>.
 */

#import <Cocoa/Cocoa.h>

/// \brief Timekeeping object
///
/// A Stopwatch computes the absolute time interval between
/// the current time and the last call to \c reset (or \c init).
@interface Stopwatch : NSObject {
    uint64_t startTime;  ///< Absolute time of last call to \c reset
}

/// \brief Set the stopwatch's begin time to the current time
- (void)reset;

/// \brief Get time interval in nanoseconds
- (uint64_t)elapsedNanoseconds;

/// \brief Get time interval in seconds
- (NSTimeInterval)elapsedTimeInterval;

@end

