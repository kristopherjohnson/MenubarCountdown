//
//  DTrace.h
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

#ifndef DTrace_h
#define DTrace_h

@import Foundation;

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
