//
//  DTrace.m
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

#import "DTrace.h"

#import "dtrace_probes.h"

void DTraceErrorMessage(NSString *message, NSString *function, NSString *file, int line)
{
    if (MENUBARCOUNTDOWN_ERROR_MESSAGE_ENABLED()) {
        MENUBARCOUNTDOWN_ERROR_MESSAGE(message.UTF8String,
                                       function.UTF8String,
                                       file.UTF8String,
                                       line);
    }
}

void DTraceDebugMessage(NSString *message, NSString *function, NSString *file, int line)
{
    if (MENUBARCOUNTDOWN_DEBUG_MESSAGE_ENABLED()) {
        MENUBARCOUNTDOWN_DEBUG_MESSAGE(message.UTF8String,
                                       function.UTF8String,
                                       file.UTF8String,
                                       line);
    }
}

void DTraceTimerTick(int secondsRemaining)
{
    MENUBARCOUNTDOWN_TIMER_TICK(secondsRemaining);
}

void DTraceTimerExpired(void)
{
    MENUBARCOUNTDOWN_TIMER_EXPIRED();
}

void DTraceStartTimer(int secondsRemaining)
{
    MENUBARCOUNTDOWN_START_TIMER(secondsRemaining);
}

void DTraceStopTimer(int secondsRemaining)
{
    MENUBARCOUNTDOWN_STOP_TIMER(secondsRemaining);
}

void DTracePauseTimer(int secondsRemaining)
{
    MENUBARCOUNTDOWN_PAUSE_TIMER(secondsRemaining);
}

void DTraceResumeTimer(int secondsRemaining)
{
    MENUBARCOUNTDOWN_RESUME_TIMER(secondsRemaining);
}

