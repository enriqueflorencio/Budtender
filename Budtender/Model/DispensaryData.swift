//
//  DispensaryData.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/31/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

///Create structs that will be loaded in with parsed JSON data from a list of dispensaries within a 20 mile radius
public struct Dispensary: Codable {
    public var data: listings
}

///Each listing will have an array of dispensaries with their names, addresses, and coordinates
public struct listings: Codable {
    public var listings: [slugInfo]
}

public struct slugInfo: Codable {
    ///A dispensary's name
    public var slug: String?
    ///A dispensary's coordinates
    public var latitude: Double?
    public var longitude: Double?
    ///A dispensary's address
    public var address: String?
}
