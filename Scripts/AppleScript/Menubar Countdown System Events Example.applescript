-- This script launches Menubar Countdown and starts it with a 25-minute timer
-- with a particular set of options.

activate application "Menubar Countdown"

tell application "System Events"
	tell process "Menubar Countdown"
		click menu bar item 1 of menu bar 1
		
		-- TODO: Figure out how to eliminate the pause that happens here.
		
		click menu item "Start…" of menu 1 of menu bar item 1 of menu bar 1
		
		tell window "Menubar Countdown Settings"
			-- Set timer to 00:25:00
			tell group 1
				set value of text field 1 to "00"
				set value of text field 2 to "25"
				set value of text field 3 to "00"
			end tell
			
			-- Set checkboxes
			my check(checkbox "Blink in menu bar")
			my uncheck(checkbox "Play system alert sound")
			my uncheck(checkbox "Show alert window")
			my check(checkbox "Show notification")
			my uncheck(checkbox "With sound")
			my check(checkbox "Speak announcement")
			
			set value of text field 1 to "The Pomodoro timer has expired."
			
			my check(checkbox "Display seconds in menu bar")
			
			click button "Start"
		end tell
	end tell
end tell

-- Set checkbox to checked state
to check(aCheckbox)
	tell application "System Events"
		if not (value of aCheckbox as boolean) then
			click aCheckbox
		end if
	end tell
end check

-- Set checkbox to unchecked state
to uncheck(aCheckbox)
	tell application "System Events"
		if (value of aCheckbox as boolean) then
			click aCheckbox
		end if
	end tell
end uncheck
