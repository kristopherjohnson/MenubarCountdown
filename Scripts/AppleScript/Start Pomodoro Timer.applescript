-- Start a 25-minute pomodoro timer

tell application "Menubar Countdown"
	
	set hours to 0
	set minutes to 25
	set seconds to 0
	
	set blink to true
	set play alert sound to false
	set show alert window to false
	-- Note: Notifications must be enabled for Menubar Countdown, or this won't work.
	set show notification to true
	set play notification sound to false
	set speak announcement to true
	set announcement text to "The timer has expired."
	
	set display seconds to true
	
	start timer
	
end tell
