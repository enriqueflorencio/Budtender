//
//  weedmapsData.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/14/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

struct WeedData: Codable {
    public var data: Weed
}

struct Weed: Codable {
    public var menu_items: [Tag]
}

struct Tag: Codable {
    public var name: String
    public var tags: [BudCategory]?
}

struct BudCategory: Codable {
    public var name: String
}
