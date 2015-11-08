//
//  StatusItemView.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/7/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
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
class StatusItemView: NSView {
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
                if isTitleBlinking { titleLayer.addBlinkAnimation() }
                else { titleLayer.removeBlinkAnimation() }

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

        iconLayer = CALayer.newLayerWithContentsFromFileNamed("MenubarIcon.png")
        iconLayer.orientBottomLeft()
        iconLayer.position = CGPointMake(StatusItemView.IconPaddingWidth, 0.0)
        backgroundLayer.addSublayer(iconLayer)

        highlightIconLayer = CALayer.newLayerWithContentsFromFileNamed("MenubarIconInverse.png")
        highlightIconLayer.orientBottomLeft()
        highlightIconLayer.position = iconLayer.position
        highlightIconLayer.hidden = true
        backgroundLayer.addSublayer(highlightIconLayer)

        titleLayer = makeTitleLayer()
        backgroundLayer.addSublayer(titleLayer)
    }

    // MARK: Drawing

    func showIcon() {
        if isTitleVisible {
            isTitleVisible = false
            titleLayer.hidden = true

            iconLayer.hidden = isMenuVisible
            highlightIconLayer.hidden = !isMenuVisible

            updateStatusItemSize()
        }
    }

    func showTitle() {
        if (!isTitleVisible) {
            isTitleVisible = true

            iconLayer.hidden = true
            highlightIconLayer.hidden = true

            updateStatusItemSize()

            titleLayer.hidden = false
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
        newLayer.bounds = CGRectMake(0.0, 0.0, desiredWidth, desiredHeight)

        // drawLayer:inContext: will set the layer's contents
        newLayer.delegate = self
        newLayer.setNeedsDisplay()

        return newLayer
    }

    func updateTitleLayer() {
        let newTitleLayer = makeTitleLayer()

        if !isTitleVisible {
            newTitleLayer.hidden = true
        }

        let oldTitleLayer = titleLayer
        titleLayer = newTitleLayer
        backgroundLayer.replaceSublayer(oldTitleLayer, with: newTitleLayer)
    }

    func titleAttributes() -> [String : AnyObject] {
        return [
            NSFontAttributeName: NSFont.menuBarFontOfSize(0),
            NSForegroundColorAttributeName: titleForegroundColor()
        ]
    }

    func titleForegroundColor() -> NSColor {
        if isMenuVisible   { return NSColor.whiteColor() }
        if isTitleBlinking { return NSColor.redColor()   }
        else               { return NSColor.blackColor() }
    }

    func titleBoundingRect() -> NSRect {
        // TODO: boundingRectWithSize(options:attributes:) is deprecated; replace appropriately
        let infiniteSize = NSMakeSize(CGFloat.infinity, CGFloat.infinity)
        return (title as NSString).boundingRectWithSize(infiniteSize,
            options: NSStringDrawingOptions(rawValue: 0),
            attributes: titleAttributes())
    }

    override func drawLayer(layer: CALayer, inContext ctx: CGContext) {
        // Set up graphics context so that we can use Application Kit drawing functions
        let nsGraphicsContext = NSGraphicsContext(CGContext: ctx, flipped: false)

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrentContext(nsGraphicsContext)

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
            statusItem.drawStatusBarBackgroundInRect(self.bounds, withHighlight: isMenuVisible)
        }
    }

    func drawTitle() {
        let position = NSMakePoint(
            StatusItemView.TitlePaddingWidth,
            StatusItemView.TitlePaddingHeight)
        (title as NSString).drawAtPoint(position, withAttributes: titleAttributes())
    }

    // MARK: Mouse and menu handling

}
