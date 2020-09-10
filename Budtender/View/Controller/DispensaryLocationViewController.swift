//
//  DispensaryLocationViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/23/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SnapKit

public class DispensaryLocationViewController: UIViewController, MKMapViewDelegate, LocationServiceDelegate {
    public func queryDispensaries() {
        
    }
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        
    }
    
    private func zoomIn() {
        var zoomRect = MKMapRect.null;
        var myx = MKMapPoint((locationService?.currentCoordinate)!)
        var f = CLLocationCoordinate2D(latitude: dispensaryLatitude, longitude: dispensaryLongitude)
        var disx = MKMapPoint(f)
        var myLocationPointRect = MKMapRect(origin: myx, size: MKMapSize(width: 0.0, height: 0.0))
        var currentDestinationPointRect = MKMapRect(origin: disx, size: MKMapSize(width: 0.0, height: 0.0))

        zoomRect = currentDestinationPointRect
        zoomRect = zoomRect.union(myLocationPointRect)
        mapView.setVisibleMapRect(zoomRect, animated: true)
    }
    
    
    private let strain: String
    private var locationService: LocationService?
    private let dispensary: String
    private let tags: [String]
    private let address: String
    private let dispensaryLatitude: Double
    private let dispensaryLongitude: Double
    
    public init(locationService: LocationService?, strain: String, dispensary: String, tags: [String], address: String, dispensaryLatitude: Double, dispensaryLongitude: Double) {
        self.locationService = locationService
        self.strain = strain
        self.dispensary = dispensary
        self.tags = tags
        self.address = address
        self.dispensaryLatitude = dispensaryLatitude
        self.dispensaryLongitude = dispensaryLongitude
        super.init(nibName: nil, bundle: nil)
    }
    
    private let strainView = UIImageView()
    private let strainLabel = UILabel()
    private let dispensaryLabel = UILabel()
    private var tagsLabel = UILabel()
    private let mapView = MKMapView()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        configureImageView()
        configureLabels()
        configureMapView()
    }
    
    /// The view isn't going back to normal. FIX THIS
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureMapView()
    }
    
    private func configureViews() {
        title = strain
        view.backgroundColor = UIColor.white
        locationService?.delegate = self
    }
    
    private func addDispensaryCoordinates() {
        let dispensaryInformation = DispensaryMap(title: dispensary, coordinate: CLLocationCoordinate2D(latitude: dispensaryLatitude, longitude: dispensaryLongitude))
        mapView.addAnnotation(dispensaryInformation)
        direct()
    }
    
    private func direct() {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locationService?.currentCoordinate!.latitude)!, longitude: (locationService?.currentCoordinate!.longitude)!), addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: dispensaryLatitude, longitude: dispensaryLongitude), addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { [unowned self] (response, error) in
            guard let unwrappedResponse = response else {
                return
            }
            
            let route = unwrappedResponse.routes[0] as MKRoute
            let distance = route.distance / 1609
            
            if(self.dispensaryLabel.text?.last == " ") {
                self.dispensaryLabel.text! += String(format: "%.1f miles", distance)
            }
            
        }
    }
    
    private func configureImageView() {
        strainView.image = UIImage(named: "cannabis")
        strainView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        strainView.layer.borderWidth = 2
        strainView.layer.cornerRadius = 3
        strainView.layer.cornerRadius = 7
        strainView.contentMode = .scaleAspectFit
        view.addSubview(strainView)
        strainView.snp.makeConstraints { (make) in
            make.width.equalTo(145)
            make.height.equalTo(120)
            make.top.equalTo(view.snp.topMargin).inset(10)
            make.left.equalTo(view.snp.left).inset(10)
        }
        
    }
    
    private func configureLabels() {
        strainLabel.text = "Product: \(strain)"
        strainLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        strainLabel.layer.borderWidth = 2
        strainLabel.numberOfLines = 3
        strainLabel.layer.cornerRadius = 3
        strainLabel.layer.cornerRadius = 7
        strainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        strainLabel.textAlignment = .center
        view.addSubview(strainLabel)
        strainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(70)
            make.top.equalTo(strainView.snp.top).inset(27)
            make.left.equalTo(strainView.snp.right).offset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
        tagsLabel.text = "Tags: "
        var cntr = 0
        for tag in tags {
            if(cntr == tags.capacity - 1) {
                tagsLabel.text! += "\(tag)"
            } else {
                tagsLabel.text! += "\(tag), "
            }
            cntr += 1
        }
        
        tagsLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        tagsLabel.layer.borderWidth = 2
        tagsLabel.layer.cornerRadius = 3
        tagsLabel.numberOfLines = 3
        tagsLabel.layer.cornerRadius = 7
        tagsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        tagsLabel.textAlignment = .center
        view.addSubview(tagsLabel)
        tagsLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.top.equalTo(strainView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
        dispensaryLabel.text = "Dispensary Name: "
        dispensaryLabel.text! += dispensary
        dispensaryLabel.text! += "\nDistance: "
        dispensaryLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        dispensaryLabel.layer.borderWidth = 2
        dispensaryLabel.layer.cornerRadius = 3
        dispensaryLabel.layer.cornerRadius = 7
        dispensaryLabel.numberOfLines = 2
        dispensaryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        dispensaryLabel.textAlignment = .center
        view.addSubview(dispensaryLabel)
        dispensaryLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.top.equalTo(tagsLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
    }
    
    private func beginUpdatingLocation() {
        mapView.showsUserLocation = true
        locationService?.locationManager.startUpdatingLocation()
    }
    
    private func configureMapView() {
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        if(locationService?.status == .authorizedAlways || locationService?.status == .authorizedWhenInUse) {
            beginUpdatingLocation()
        }
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.width.equalTo(340)
            make.height.equalTo(280)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.top.equalTo(dispensaryLabel.snp.bottom).offset(15)
            
        }
        addDispensaryCoordinates()
        zoomIn()
    }

}
