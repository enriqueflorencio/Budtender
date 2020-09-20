//
//  Herb.swift
//  Budtender
//
//  Created by Enrique Florencio on 9/5/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import UIKit

///Struct that holds information that will be used to initialize the dispensary view controller.
public struct Herb {
    ///Name of the product
    public let name: String
    ///Tags that are exclusive to this product
    public var tags: [Tag]
    ///Name of the dispensary where you can find this product
    public var slug: String
    ///Coordinates of the dispensary
    public var latitude: Double
    public var longitude: Double
    ///Address of the dispensary
    public var address: String
    public var locationService: LocationService
    public var herbImageURL: String
}
