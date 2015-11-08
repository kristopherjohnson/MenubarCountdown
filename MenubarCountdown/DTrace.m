//
//  DTrace.m
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

