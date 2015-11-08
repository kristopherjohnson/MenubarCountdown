#!/usr/sbin/dtrace -s

/*
 * This dtrace script prints output for all probes generated
 * by Menubar Countdown.
 *
 * See MenubarCountdown/dtrace_probes.d for declarations of the
 * probes.
 */

#pragma D option quiet

MenubarCountdown::error-message
{
    printf("%Y | ERROR: %s [%s %s:%d]\n", walltimestamp,
        copyinstr(arg0), copyinstr(arg1), copyinstr(arg2), arg3);
}

MenubarCountdown::debug-message
{
    printf("%Y | DEBUG: %s [%s %s:%d]\n", walltimestamp,
        copyinstr(arg0), copyinstr(arg1), copyinstr(arg2), arg3);
}

MenubarCountdown::timer-tick
{
    printf("%Y | timer-tick: %ds remaining\n", walltimestamp,
        arg0);
}

MenubarCountdown::timer-expired
{
    printf("%Y | timer-expired\n", walltimestamp);
}

MenubarCountdown::start-timer
{
    printf("%Y | start-timer: %ds remaining\n", walltimestamp,
        arg0);
}

MenubarCountdown::stop-timer
{
    printf("%Y | stop-timer: %ds remaining\n", walltimestamp,
        arg0);
}

MenubarCountdown::pause-timer
{
    printf("%Y | pause-timer: %ds remaining\n", walltimestamp,
        arg0);
}

MenubarCountdown::resume-timer
{
    printf("%Y | resume-timer: %ds remaining\n", walltimestamp,
        arg0);
}


