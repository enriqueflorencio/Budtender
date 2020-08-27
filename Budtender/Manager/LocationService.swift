//
//  LocationManager.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/24/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import MapKit

public protocol LocationServiceDelegate {
    func notifyStatus(status: CLAuthorizationStatus)
    func zoomToLatestLocation(coordinate: CLLocationCoordinate2D)
}

public class LocationService: NSObject, CLLocationManagerDelegate {
    
    public let locationManager: CLLocationManager
    
    public var delegate: LocationServiceDelegate?
    
    public var status: CLAuthorizationStatus?
    
    private var currentCoordinate: CLLocationCoordinate2D?
    
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    public func setupLocationServices() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        //checkLocationAuthorization()
        
    }
    
    public func getStatus() -> CLAuthorizationStatus? {
        return self.status
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
        self.status = status
        delegate?.notifyStatus(status: status)
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("UPDATED LOCATION")
        guard let latestLocation = locations.first else {
            return
        }
        
        if(currentCoordinate == nil) {
            delegate?.zoomToLatestLocation(coordinate: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
    }
    
}
