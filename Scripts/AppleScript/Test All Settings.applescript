-- This script sets the values of all elements of the Settings window,
-- pauses for two seconds, then sets all the elements to different values.

-- Run this with the Menubar Countdown Settings window already displayed.
-- (Start Menubar Countdown and choose the Start... menu item if it is not
-- showing.)

tell application "Menubar Countdown"
	
	set hours to 99
	set minutes to 59
	set seconds to 59
	
	set blink to false
	set play alert sound to false
	set repeat alert sound to false
	set show alert window to false
	set show notification to false
	set play notification sound to false
	set speak announcement to false
	
	set announcement text to "The checkboxes should all be off now."
	
	set display seconds to false
	set show start dialog on launch to false
	
	delay 2
	
	set hours to 0
	set minutes to 25
	set seconds to 0
	
	set blink to true
	set play alert sound to true
	set repeat alert sound to true
	set show alert window to true
	set show notification to true
	set play notification sound to true
	set speak announcement to true
	
	set announcement text to "The checkboxes should all be on now."
	
	set display seconds to true
	set show start dialog on launch to true
end tell
