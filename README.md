Menubar Countdown
-----------------

Copyright 2009,2015,2019 Kristopher Johnson


_Menubar Countdown_ is a simple countdown timer that displays itself on the
macOS menu bar.

To set the timer, click the menu bar icon and select the **Start...** menu item.
A dialog will appear allowing you to specify the countdown time in hours,
minutes, and seconds. The dialog also allows you to specify which of the
following forms of notification you want when the timer gets down to 00:00:00:

- Blink the icon in the menu bar
- Play the system alert sound
- Display an alert window
- Make a spoken announcement. You can specify the text to be spoken.

Releases are available at <https://github.com/kristopherjohnson/MenubarCountdown/releases>.

The current 2.0 version of Menubar Countdown requires macOS Mojave 10.14.4 or
newer.  It is compatible with macOS Catalina 10.15.

For older versions of macOS (10.5 to 10.14.3), you can use version 1.2,
available from <http://s3.amazonaws.com/capablehands/downloads/MenubarCountdown-1.2.zip>


LICENSE

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


RELEASE NOTES

v2.0 (work in progress)

- Updated for macOS 10.14 and newer, with 64-bit support
- Code translated to Swift
- When timer is stopped, menubar displays small hourglass icon rather than 00:00:00, to conserve menubar space.
- Add option to repeat alert sound after timer expiration, until it is acknowledged
- Add option to blink 00:00:00 in the menu bar after timer expiration, until it is acknowledged
- Add Pause menu item.
- Remove support for Growl

v1.2 (2009/06/22)

- New application icon
- Command-X, Command-C, Command-V, and Command-A now work in the text fields in the settings dialog
- Command-R is now a shortcut key for the Restart Countdown... button in the alert window
- Add option to hide seconds in menu bar
- Show start-timer dialog when application launches
- Add Growl notifications.  The Announcement text specified in the Start dialog will be displayed in the Growl notification window.

v1.1 (2009/04/20)

- timer-expired alert window floats above other applications' windows
- added application icon
- added Doxygen comments to source code

v1.0 (2009/04/09)

- initial release


