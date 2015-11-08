//
//  StringExtensions.swift
//  MenubarCountdown
//
//  Created by Kristopher Johnson on 11/8/15.
//  Copyright © 2015 Kristopher Johnson. All rights reserved.
//

import Foundation

extension String {
    /// The last path component of the string
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
}
