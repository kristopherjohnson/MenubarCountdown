//
//  CALayerTransactionExtensions.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/7/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Cocoa

extension CATransaction {
    func disableActions() {
        CATransaction.setValue(kCFBooleanTrue,
            forKey: kCATransactionDisableActions)
    }
}

extension CATransaction {
    func setDuration(duration: Float) {
        CATransaction.setValue(NSNumber(float: duration),
            forKey: kCATransactionAnimationDuration)
    }
}
