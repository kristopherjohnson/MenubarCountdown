tell application "Menubar Countdown"
	activate
	
	show start dialog
	
	say "The name of the application is " & name & "."
	say "The version is " & version & "."
	if frontmost then
		say "The application is frontmost."
	else
		say "The application is not frontmost."
	end if
	
	quit
end tell
