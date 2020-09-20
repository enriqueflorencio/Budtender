//
//  LocationManager.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/24/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import MapKit

///Protocol that our view controller needs to conform to
public protocol LocationServiceDelegate: class {
    func notifyStatus(status: CLAuthorizationStatus)
    func queryDispensaries()
}

/// Location Service will act as a wrapper for for the CoreLocation Manager. This service manager will calculate the coordinates of a dispensary and a user's location
public class LocationService: NSObject, CLLocationManagerDelegate {
    
    // MARK: Public/Private Variables
    
    ///Our location manager
    public let locationManager: CLLocationManager
    
    ///This radius will be utilized to approximate a user's bounding box. This will span 20 miles from where a user is and find the dispensaries within those 20 miles
    private var radius: Double = 3598.6025823771
    
    ///The view controller will make itself the delegate in order to be notified of any significant changes
    weak public var delegate: LocationServiceDelegate?
    
    ///We'll be storing the user's status to giving us access to their location (always allow, when in use, denied, etc.)
    public var status: CLAuthorizationStatus?
    
    ///The user's current coordinate
    public var currentCoordinate: CLLocationCoordinate2D?
    
    ///These four variables will be plugged into the weedmaps API for finding dispensaries within a user's 20 mile radius
    private var bottomLatitude: Double?
    private var bottomLongitude: Double?
    private var topLatitude: Double?
    private var topLongitude: Double?
    
    // MARK: Constructor
    
    ///This location service needs a location manager
    public init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    // MARK: Location Manager Setup
    
    ///Set this location service as the delegate of the locationManager
    public func setupLocationServices() {
        locationManager.delegate = self
        ///We want the best available accuracy in order to correctly calculate the user's distance from the dispensary
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        ///Request the user for authorization when using this app
        locationManager.requestWhenInUseAuthorization()
        
    }
    
    // MARK: User Permission/Status Functions
    
    ///Get the current status of the user's permission
    public func getStatus() -> CLAuthorizationStatus? {
        guard let userStatus = self.status else {
            return nil
        }
        return userStatus
    }
    
    ///We can determine a user's status by using a switch case
    public func checkLocationAuthorization() {
        switch self.status {
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
    
    // MARK: Calculations
    
    ///This will calculate a user's bounding box which will be used inside the weedmaps API
    private func makeBoundingBox(coordinate: CLLocationCoordinate2D) {
        ///Okay if I'm being honest, my housemates are physics majors and they helped me with this calculation. Credit to Ethan Custodio and Stefan Faaland (You guys are gonna tear it up in grad school)
        var deltay = radius / (111111)
        var deltax = radius / (111111 * cos(coordinate.latitude))
        
        topLatitude = deltax + coordinate.longitude
        topLongitude = deltay + coordinate.latitude
        bottomLatitude = coordinate.longitude - deltax
        bottomLongitude = coordinate.latitude - deltay
        
        ///Once the user's bounding box is calculated, we're going to fetch the dispensaries nearby within a 20 mile radius
        delegate?.queryDispensaries()

    }
    
    // MARK: Bounding Box Coordinates
    
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
    
    // MARK: Location Manager Delegate Functions
    
    ///Set our status equal to what the user agreed to. If they denied our permission then we have to show them an alert controller telling them that this app doesn't work without their permission.
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.status = status
        delegate?.notifyStatus(status: status)
    }
    
    ///We need to update our coordinate variable with the user's current location and we need to setup the bounding box in this function.
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {
            return
        }
        
        if(currentCoordinate == nil) {
            ///Make the bounding box immediately
            makeBoundingBox(coordinate: latestLocation.coordinate)
        }
        
        currentCoordinate = latestLocation.coordinate
        
    }
    
}
