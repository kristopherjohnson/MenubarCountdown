provider MenubarCountdown
{
    /* Fired by Log.error() */
    probe error__message(char* message, char* function, char* file, int line);

    /* Fired by Log.debug() */
    probe debug__message(char* message, char* function, char* file, int line);

    /* Fired when the once-per-second timer ticks during countdown */
    probe timer__tick(int secondsRemaining);

    /* Fired when the countdown timer reaches zero */
    probe timer__expired();

    /* Fired when user clicks Start */
    probe start__timer(int secondsRemaining);

    /* Fired when user clicks Stop */
    probe stop__timer(int secondsRemaining);

    /* Fired when user clicks Pause */
    probe pause__timer(int secondsRemaining);

    /* Fired when user clicks Resume */
    probe resume__timer(int secondsRemaining);
};
