//
//  Localizable.swift
//  Budtender
//
//  Created by Enrique Florencio on 11/9/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//
// from: http://www.popcornomnom.com/ios-localization-swift-5/

import Foundation

protocol LocalizableDelegate {
    var rawValue: String { get }
    var table: String? { get }
    var localized: String { get }
}

extension LocalizableDelegate {

    //returns a localized value by specified key located in the specified table
    var localized: String {
        return Bundle.main.localizedString(forKey: rawValue, value: nil, table: table)
    }

    // file name, where to find the localized key
    // by default is the Localizable.string table
    var table: String? {
        return nil
    }
}
