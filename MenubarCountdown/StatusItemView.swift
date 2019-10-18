//
//  StatusItemView.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.
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

/// Custom view for status item
///
/// StatusItemView implements the custom view for the menubar status item.
///
/// StatusItemView uses layers to display its content.  There are four layers:
///
/// - the background/root layer, which draws the background and hosts the other layers
///
/// - the icon layer, which is a 22x22 image displayed in the menu bar
///
/// - the highlighted icon layer, which is the inverse to the icon layer, displayed
///   when the menu is popped up, and hidden otherwise
///
/// - the title layer, which displays a string
///
/// The application can switch between displaying the icon and displaying the string
/// by calling `showIcon` and `showTitle`, respectively.
///
/// The application can cause the title to blink by setting the `isTitleBlinking` property.
///
class StatusItemView: NSView, NSMenuDelegate, CALayerDelegate {
    static let IconPaddingWidth = CGFloat(3)
    static let TitlePaddingWidth = CGFloat(6)
    static let TitlePaddingHeight = CGFloat(3)

    var statusItem: NSStatusItem?

    var title: String = "" {
        didSet {
            if titleLayer != nil { updateTitleLayer() }
            if statusItem != nil { updateStatusItemSize() }
        }
    }

    var isTitleVisible = false

    var isMenuVisible = false

    var isTitleBlinking = false {
        didSet {
            if titleLayer != nil {
                if isTitleBlinking {
                    titleLayer.addBlinkAnimation()
                    
                }
                else {
                    titleLayer.removeBlinkAnimation()
                }

                titleLayer.setNeedsDisplay()
            }
        }
    }

    var backgroundLayer: CALayer!
    var titleLayer: CALayer!
    var iconLayer: CALayer!
    var highlightIconLayer: CALayer!

    // MARK: Initialization
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        initializeLayers()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initializeLayers() {
        self.wantsLayer = true

        backgroundLayer = self.layer

        iconLayer = CALayer.newLayerFromImageResource(name: "MenubarIcon.png")
        iconLayer.orientBottomLeft()
        iconLayer.position = CGPoint(x: StatusItemView.IconPaddingWidth, y: 0.0)
        backgroundLayer.addSublayer(iconLayer)

        highlightIconLayer = CALayer.newLayerFromImageResource(name: "MenubarIconInverse.png")
        highlightIconLayer.orientBottomLeft()
        highlightIconLayer.position = iconLayer.position
        highlightIconLayer.isHidden = true
        backgroundLayer.addSublayer(highlightIconLayer)

        titleLayer = makeTitleLayer()
        backgroundLayer.addSublayer(titleLayer)
    }

    // MARK: Drawing

    func showIcon() {
        if isTitleVisible {
            isTitleVisible = false
            titleLayer.isHidden = true

            iconLayer.isHidden = isMenuVisible
            highlightIconLayer.isHidden = !isMenuVisible

            updateStatusItemSize()
        }
    }

    func showTitle() {
        if (!isTitleVisible) {
            isTitleVisible = true

            iconLayer.isHidden = true
            highlightIconLayer.isHidden = true

            updateStatusItemSize()

            titleLayer.isHidden = false
        }
    }

    func updateStatusItemSize() {
        if let statusItem = statusItem {
            let currentWidth = statusItem.length
            let newWidth = isTitleVisible
                ? titleLayer.bounds.size.width
                : iconLayer.bounds.size.width
            if newWidth != currentWidth {
                statusItem.length = newWidth
                backgroundLayer.setNeedsDisplay()
            }
        }
    }

    func makeTitleLayer() -> CALayer {
        let newLayer = CALayer()

        newLayer.orientBottomLeft()

        let titleBounds = titleBoundingRect()
        let desiredWidth = titleBounds.size.width + 2 * StatusItemView.TitlePaddingWidth
        let desiredHeight = self.bounds.size.height
        newLayer.bounds = CGRect(x: 0.0, y: 0.0, width: desiredWidth, height: desiredHeight)

        // drawLayer:inContext: will set the layer's contents
        newLayer.delegate = self
        newLayer.setNeedsDisplay()

        return newLayer
    }

    func updateTitleLayer() {
        let newTitleLayer = makeTitleLayer()

        if !isTitleVisible {
            newTitleLayer.isHidden = true
        }

        // #KJ TODO: what do we do if titleLayer is nil?
        if let oldTitleLayer = titleLayer {
            titleLayer = newTitleLayer
            backgroundLayer.replaceSublayer(oldTitleLayer, with: newTitleLayer)
        }
    }

    func titleAttributes() -> [NSAttributedString.Key : Any] {
        return [
            NSAttributedString.Key.font: NSFont.menuBarFont(ofSize: 0),
            NSAttributedString.Key.foregroundColor: titleForegroundColor()
        ]
    }

    func titleForegroundColor() -> NSColor {
        if isMenuVisible   { return NSColor.white }
        if isTitleBlinking { return NSColor.red   }
        else               { return NSColor.black }
    }

    func titleBoundingRect() -> NSRect {
        // TODO: boundingRectWithSize(options:attributes:) is deprecated; replace appropriately
        let infiniteSize = NSMakeSize(CGFloat.infinity, CGFloat.infinity)
        return (title as NSString).boundingRect(with: infiniteSize,
                                                options: NSString.DrawingOptions(rawValue: 0),
                                                attributes: titleAttributes())
    }

    func draw(_ layer: CALayer, in ctx: CGContext) {
        // Set up graphics context so that we can use Application Kit drawing functions
        let nsGraphicsContext = NSGraphicsContext(cgContext: ctx, flipped: false)

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsGraphicsContext

        if layer == backgroundLayer {
            drawBackground()
        }
        else if layer == titleLayer {
            drawTitle()
        }

        NSGraphicsContext.restoreGraphicsState()
    }

    func drawBackground() {
        if let statusItem = statusItem {
            // #KJ TODO: Eliminate use of this deprecated method
            statusItem.drawStatusBarBackground(in: self.bounds, withHighlight: isMenuVisible)
        }
    }

    func drawTitle() {
        let position = NSMakePoint(
            StatusItemView.TitlePaddingWidth,
            StatusItemView.TitlePaddingHeight)
        (title as NSString).draw(at: position, withAttributes: titleAttributes())
    }

    // MARK: Mouse and menu handling

    override func mouseDown(with event: NSEvent) {
        if let menu = menu {
            menu.delegate = self
            if let statusItem = statusItem {
                // #KJ TODO: popUpMenu is deprecated
                statusItem.popUpMenu(menu)
            }
            else {
                Log.error("statusItem property not set")
            }
        }
        else {
            Log.error("menu property not set")
        }
    }

    override func rightMouseDown(with event: NSEvent) {
        // Treat right-click just like left-click
        mouseDown(with: event)
    }

    func menuWillOpen(_ menu: NSMenu) {
        isMenuVisible = true

        // Disable animation for the following changes
        // (menu highlighting needs to be instantaneous)
        CATransaction.begin()
        CATransaction.disableActions()

        // Need to highlight the background
        backgroundLayer.setNeedsDisplay()
        if isTitleVisible {
            // The title's color will change
            titleLayer.setNeedsDisplay()
        }
        else {
            // Hide the normal icon and show the highlighted icon
            iconLayer.isHidden = true
            highlightIconLayer.isHidden = false
        }

        CATransaction.commit()
    }

    func menuDidClose(_ menu: NSMenu) {
        isMenuVisible = false
        menu.delegate = nil

        // Disable animation for the following changes
        // (menu highlighting needs to be instantaneous)
        CATransaction.begin()
        CATransaction.disableActions()

        // Unhighlight the background
        backgroundLayer.setNeedsDisplay()

        if isTitleVisible {
            // Restore title color
            titleLayer.setNeedsDisplay()
        }
        else {
            // Show the normal icon and hide the highlighted icon
            iconLayer.isHidden = false
            highlightIconLayer.isHidden = true
        }

        CATransaction.commit()
    }
}
