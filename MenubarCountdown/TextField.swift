//
//  TextField.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

/**
 Subclass of NSTextField that handles Cmd-X, Cmd-C, Cmd-V, and Cmd-A

 This class is used instead of the standard NSTextField in the Start.. dialog
 to allow the user to use the standard edit keyboard shortcuts even though the
 application has no Edit menu.

 This class is based on code found at <http://www.cocoarocket.com/articles/copypaste.html>
 which was written by James Huddleston, and improvements discussed at
 <http://stackoverflow.com/questions/970707/cocoa-keyboard-shortcuts-in-dialog-without-an-edit-menu>.
 */
final class TextField: NSTextField {
    override func performKeyEquivalent(with key: NSEvent) -> Bool {
        // Map Command-X to Cut
        //     Command-C to Copy
        //     Command-V to Paste
        //     Command-A to Select All
        if key.type == .keyDown {
            let commandKeyMask = NSEvent.ModifierFlags.command.rawValue

            let modifierFlagsMask = key.modifierFlags.rawValue
                & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue

            if modifierFlagsMask == commandKeyMask {
                if let chars = key.charactersIgnoringModifiers {
                    switch chars {
                    case "x":
                        return sendToFirstResponder(#selector(NSText.cut(_:)))
                    case "c":
                        return sendToFirstResponder(#selector(NSObject.copy as () -> Any))
                    case "v":
                        return sendToFirstResponder(#selector(NSText.paste(_:)))
                    case "a":
                        return sendToFirstResponder(#selector(NSStandardKeyBindingResponding.selectAll(_:)))
                    default:
                        break
                    }
                }
            }
        }

        return super.performKeyEquivalent(with: key)
    }

    /**
     Send the specified selector to the first responder.

     - parameter action: The selector to be sent.

     - returns: `true` if the action was successfully sent; otherwise `false`.
     */
    func sendToFirstResponder(_ action: Selector) -> Bool {
        return NSApp.sendAction(action,
                                to: self.window?.firstResponder,
                                from: self)
    }
}
