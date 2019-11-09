tell application "Menubar Countdown"
	show start dialog
	
	say "Setting up test"
	
	set hours to 0
	set minutes to 0
	set seconds to 15
	set display seconds to true
	set announcement text to "Testing Menubar Countdown commands."
	
	delay 2
	
	start timer
	say "Timer started"
	
	delay 5
	
	pause timer
	if paused then
		say "Timer paused"
	else
		display dialog "Timer should be paused, but isn't."
	end if
	
	delay 5
	
	resume timer
	if paused then
		display dialog "Timer should not be paused, but is."
	else
		say "Timer resumed"
	end if
	
	delay 5
	
	stop timer
	say "Timer stopped"
end tell
