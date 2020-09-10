//
//  weedmapsData.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/14/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation

///Create structs that will be loaded in with parsed JSON data from a specifc dispensary
public struct DispensaryDetails: Codable {
    public var data: Menu
}

///The menu from a specific dispensary
public struct Menu: Codable {
    public var menu_items: [Product]
}

///Within this menu, there are products with their names and tags
public struct Product: Codable {
    public var name: String
    public var avatar_image: Avatar?
    public var tags: [Tag]?
}

public struct Avatar: Codable {
    public var original_url: String?
}

///A tag could be relaxed, giggly, euphoric, etc.
public struct Tag: Codable {
    public var name: String
}
