//
//  TextField.h
//  MenuTimer
//
//  Created by Kristopher Johnson on 6/11/09.
//  Copyright 2009 Capable Hands Technologies, Inc.. All rights reserved.
//
//  This file is part of Menubar Countdown.
//
//  Menubar Countdown is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Menubar Countdown is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with Menubar Countdown.  If not, see <http://www.gnu.org/licenses/>.

#import <Cocoa/Cocoa.h>

/// \brief Subclass of NSTextField that handles Cmd-X, Cmd-C, Cmd-V, and Cmd-A
///
/// This class is used instead of the standard NSTextField in the Start.. dialog
/// to allow the user to use the standard edit keyboard shortcuts even though the
/// application has no Edit menu.
///
/// This class is based on code found at http://www.cocoarocket.com/articles/copypaste.html
/// which was written by James Huddleston.
@interface TextField : NSTextField {
}

@end
