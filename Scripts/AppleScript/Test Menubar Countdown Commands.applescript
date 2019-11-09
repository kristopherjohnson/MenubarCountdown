tell application "Menubar Countdown"
	
	activate
	
	show start dialog
	
	say "Setting up test"
	
	set hours to 0
	set minutes to 0
	set seconds to 30
	set display seconds to true
	set announcement text to "Testing Menubar Countdown commands."
	
	delay 2
	
	start timer
	say "Timer started."
	say (time remaining as text) & " seconds remaining."
	
	if timer has expired then
		display dialog "Timer has expired, but should not have."
	end if
	if timer is paused then
		display dialog "Timer is paused, but should not be."
	end if
	
	delay 5
	
	pause timer
	if timer is paused then
		say "Timer is paused."
		say (time remaining as text) & " seconds remaining."
	else
		display dialog "Timer should be paused, but isn't."
	end if
	
	delay 5
	
	resume timer
	if timer is paused then
		display dialog "Timer should not be paused, but is."
	else
		say "Timer resumed."
		say (time remaining as text) & " seconds remaining."
	end if
	
	delay 5
	
	stop timer
	say "Timer stopped"
	say (time remaining as text) & " seconds remaining."
	
	quit
end tell
