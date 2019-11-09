tell application "Menubar Countdown"
	show start dialog
	
	say "Setting up"
	
	set hours to 0
	set minutes to 0
	set seconds to 30
	set display seconds to true
	set announcement text to "Testing Menubar Countdown commands."
	
	delay 2
	
	start timer
	say "Timer started"
	
	delay 5
	
	pause timer
	say "Timer paused"
	
	delay 5
	
	resume timer
	say "Timer resumed"
	
	delay 5
	
	stop timer
	say "Timer stopped"
end tell
