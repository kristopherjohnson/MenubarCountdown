//
//  DTrace.h
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

#ifndef DTrace_h
#define DTrace_h

#import <Foundation/Foundation.h>

// These Objective-C functions invoke the DTrace probes defined in dtrace_probes.d

extern void DTraceErrorMessage(NSString *message, NSString *function, NSString *file, int line);

extern void DTraceDebugMessage(NSString *message, NSString *function, NSString *file, int line);

extern void DTraceTimerTick(int secondsRemaining);

extern void DTraceTimerExpired(void);

extern void DTraceStartTimer(int secondsRemaining);

extern void DTraceStopTimer(int secondsRemaining);

extern void DTracePauseTimer(int secondsRemaining);

extern void DTraceResumeTimer(int secondsRemaining);

#endif /* DTrace_h */
