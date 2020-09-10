//
//  DispensaryMap.swift
//  Budtender
//
//  Created by Enrique Florencio on 9/6/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import MapKit

///Annotation for a dispensary that will be displayed onto our MapView
public class DispensaryMap: NSObject, MKAnnotation {
    ///Name of the dispensary
    public var title: String?
    ///The coordinates of the dispensary
    public var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
