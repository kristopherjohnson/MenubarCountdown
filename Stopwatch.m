/*
 *  Stopwatch.m
 *  MenuTimer
 *
 *  Created by Kristopher Johnson on 3/15/09.
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

#include "Stopwatch.h"
#include <CoreServices/CoreServices.h>
#include <mach/mach_time.h>


@implementation Stopwatch


- (id)init {
    [self reset];
    return self;
}


- (void)reset {
    startTime = mach_absolute_time();
}


- (uint64_t)elapsedNanoseconds {
    // See http://developer.apple.com/qa/qa2004/qa1398.html for details about this code

    const uint64_t now = mach_absolute_time();
    const uint64_t elapsed = now - startTime;

    Nanoseconds elapsedNano = AbsoluteToNanoseconds(*(AbsoluteTime *)&elapsed);
    return *(uint64_t *)&elapsedNano;
}


- (NSTimeInterval)elapsedTimeInterval {
    return (double)[self elapsedNanoseconds] * 1.0e-9;
}


@end
