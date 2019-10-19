//
//  StringExtensions.swift
//  MenubarCountdown
//
//  Copyright © 2009,2015,2019 Kristopher Johnson. All rights reserved.

import Foundation

extension String {
    /// The last path component of the string
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
}
