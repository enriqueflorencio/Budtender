//
//  Herb.swift
//  Budtender
//
//  Created by Enrique Florencio on 9/5/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

public struct Herb {
    public let name: String
    public var tags: [BudCategory]
    public var slug: String
    public var latitude: Double
    public var longitude: Double
    public var address: String
    public var locationService: LocationService
}
