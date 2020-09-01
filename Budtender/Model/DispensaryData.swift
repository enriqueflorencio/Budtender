//
//  DispensaryData.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/31/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

public struct Dispensary: Codable {
    public var data: listings
}

public struct listings: Codable {
    public var listings: [slugs]
}

public struct slugs: Codable {
    public var slug: String?
    public var latitude: Double?
    public var longitude: Double?
    public var address: String?
}
