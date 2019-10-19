//
//  CALayerTransactionExtensions.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Cocoa

extension CATransaction {
    func disableActions() {
        CATransaction.setValue(kCFBooleanTrue,
            forKey: kCATransactionDisableActions)
    }
}

extension CATransaction {
    func setDuration(duration: Float) {
        CATransaction.setValue(NSNumber(value: duration),
            forKey: kCATransactionAnimationDuration)
    }
}
