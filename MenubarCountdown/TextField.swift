//
//  TextField.swift
//  MenubarCountdown
//
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
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
//

import Cocoa

/// Subclass of NSTextField that handles Cmd-X, Cmd-C, Cmd-V, and Cmd-A
///
/// This class is used instead of the standard NSTextField in the Start.. dialog
/// to allow the user to use the standard edit keyboard shortcuts even though the
/// application has no Edit menu.
///
/// This class is based on code found at http://www.cocoarocket.com/articles/copypaste.html
/// which was written by James Huddleston, and improvements discussed at
/// http://stackoverflow.com/questions/970707/cocoa-keyboard-shortcuts-in-dialog-without-an-edit-menu

class TextField: NSTextField {
    override func performKeyEquivalent(event: NSEvent) -> Bool {
        // Map Command-X to Cut
        //     Command-C to Copy
        //     Command-V to Paste
        //     Command-A to Select All
        //     Command-Z to Undo
        //     Command-Shift-Z to Redo
        if event.type == NSEventType.KeyDown {
            let commandKeyMask = NSEventModifierFlags.CommandKeyMask.rawValue
            let commandShiftKeyMask = commandKeyMask | NSEventModifierFlags.ShiftKeyMask.rawValue

            let modifierFlagsMask = event.modifierFlags.rawValue
                & NSEventModifierFlags.DeviceIndependentModifierFlagsMask.rawValue

            if modifierFlagsMask == commandKeyMask {
                if let chars = event.charactersIgnoringModifiers {
                    switch chars {
                    case "x": return sendFirstResponderAction(Selector("cut:"))
                    case "c": return sendFirstResponderAction(Selector("copy"))
                    case "v": return sendFirstResponderAction(Selector("paste:"))
                    case "a": return sendFirstResponderAction(Selector("selectAll:"))
                    case "z": return sendFirstResponderAction(Selector("undo:"))
                    default:  break
                    }
                }
            }
            else if modifierFlagsMask == commandShiftKeyMask {
                if let chars = event.charactersIgnoringModifiers {
                    switch chars {
                    case "Z": return sendFirstResponderAction(Selector("redo:"))
                    default:  break
                    }
                }
            }
        }

        return super.performKeyEquivalent(event)
    }

    func sendFirstResponderAction(action: Selector) -> Bool {
        return NSApp.sendAction(action, to: self.window?.firstResponder, from: self)
    }
}