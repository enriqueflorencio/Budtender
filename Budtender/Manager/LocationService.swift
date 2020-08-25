//
//  LocationManager.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/24/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import MapKit

public class LocationService: NSObject, CLLocationManagerDelegate {
    
    private let locationManager: CLLocationManager
    
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    public func setupLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //checkLocationAuthorization()
        
    }
    
    public func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("WHEN IN USE")
        case .authorizedAlways:
            print("ALWAYS")
        case .denied:
            print("DENIED")
        case .notDetermined:
            print("NOT DETERMINED")
        case .restricted:
            print("RESTRICTED")
        @unknown default:
            print("UNKNOWN")
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("CHANGED")
    }
    
}
