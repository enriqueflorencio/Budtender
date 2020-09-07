//
//  DispensaryMap.swift
//  Budtender
//
//  Created by Enrique Florencio on 9/6/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import MapKit

public class DispensaryMap: NSObject, MKAnnotation {
    public var title: String?
    public var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
