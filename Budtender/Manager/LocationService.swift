//
//  LocationManager.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/24/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import MapKit

public protocol LocationServiceDelegate: class {
    func notifyStatus(status: CLAuthorizationStatus)
    func zoomToLatestLocation(coordinate: CLLocationCoordinate2D)
    func queryDispensaries()
}

public class LocationService: NSObject, CLLocationManagerDelegate {
    
    public let locationManager: CLLocationManager
    
    private var radius: Double = 3598.6025823771
    
    weak public var delegate: LocationServiceDelegate?
    
    public var status: CLAuthorizationStatus?
    
    public var currentCoordinate: CLLocationCoordinate2D?
    
    private var bottomLatitude: Double?
    private var bottomLongitude: Double?
    private var topLatitude: Double?
    private var topLongitude: Double?
    
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
    
    private func makeBoundingBox(coordinate: CLLocationCoordinate2D) {
        var deltay = radius / (111111)
        var deltax = radius / (111111 * cos(coordinate.latitude))
        
        topLatitude = deltax + coordinate.longitude
        topLongitude = deltay + coordinate.latitude
        bottomLatitude = coordinate.longitude - deltax
        bottomLongitude = coordinate.latitude - deltay
        
        delegate?.queryDispensaries()

    }
    
    public func getBottomLongitude() -> Double? {
        guard let bottomLong = bottomLongitude else {
            return nil
        }
        return bottomLong
    }
    
    public func getBottomLatitude() -> Double? {
        guard let bottomLat = bottomLatitude else {
            return nil
        }
        
        return bottomLat
    }
    
    public func getTopLongitude() -> Double? {
        guard let topLong = topLongitude else {
            return nil
        }
        
        return topLong
    }
    
    public func getTopLatitude() -> Double? {
        guard let topLat = topLatitude else {
            return nil
        }
        
        return topLat
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
            makeBoundingBox(coordinate: latestLocation.coordinate)
        }
        
        
        
        currentCoordinate = latestLocation.coordinate
        
    }
    
}
