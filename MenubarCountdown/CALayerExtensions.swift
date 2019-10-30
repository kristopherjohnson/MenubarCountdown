//
//  CALayerExtensions.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

// MARK: Add/remove blink animation
extension CALayer {
    /**
     Unique key used to identify animation managed by `addBlinkAnimation` and `removeBlinkAnimation`.
     */
    @nonobjc static let blinkAnimationKey
        = "MenubarCountdown_CALayerExtensions_BlinkAnimation"

    /**
     Add a repeating blinking animiation to the layer.

     Call `removeBlinkAnimation` to stop the animation.
     */
    func addBlinkAnimation() {
        if let _ = animation(forKey: CALayer.blinkAnimationKey) {
            return
        }

        let animation = CABasicAnimation(keyPath: "opacity")

        // Repeat forever, once per second
        animation.repeatCount = Float.infinity
        animation.duration = 0.5
        animation.autoreverses = true

        // Cycle between 0 and full opacity
        animation.fromValue = 0.0
        animation.toValue = 1.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)

        add(animation, forKey: CALayer.blinkAnimationKey)
    }

    /**
     Remove animation added by `addBlinkAnimation`.
     */
    func removeBlinkAnimation() {
        removeAnimation(forKey: CALayer.blinkAnimationKey)
    }
}
