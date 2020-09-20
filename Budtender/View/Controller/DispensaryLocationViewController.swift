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

public class DispensaryLocationViewController: UIViewController, MKMapViewDelegate {
    
    // MARK: Private Variables
    
    private var locationService: LocationService?
    private let strain: String
    private let dispensary: String
    private let tags: [String]
    private let address: String
    private let dispensaryLatitude: Double
    private let dispensaryLongitude: Double
    private let productURL: String
    private let strainView = UIImageView()
    private let strainLabel = UILabel()
    private let dispensaryLabel = UILabel()
    private var tagsLabel = UILabel()
    private let mapView = MKMapView()
    
    // MARK: Constructor Methods
    
    public init(locationService: LocationService?, strain: String, dispensary: String, tags: [String], address: String, dispensaryLatitude: Double, dispensaryLongitude: Double, productURL: String) {
        self.locationService = locationService
        self.strain = strain
        self.dispensary = dispensary
        self.tags = tags
        self.address = address
        self.dispensaryLatitude = dispensaryLatitude
        self.dispensaryLongitude = dispensaryLongitude
        self.productURL = productURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Controller Life Cycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureImageView()
        configureLabels()
        configureMapView()
    }
    
    // MARK: UI Methods
    
    private func configureView() {
        title = strain
        view.backgroundColor = UIColor.white
    }
    
    private func configureImageView() {
        ///Check for the image in the cache
        strainView.image = UIImage(named: "cannabis")
        fetchImageView()
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
        dispensaryLabel.text! += "\nAddress: \(address)"
        dispensaryLabel.text! += "\nDistance: "
        dispensaryLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        dispensaryLabel.layer.borderWidth = 2
        dispensaryLabel.layer.cornerRadius = 3
        dispensaryLabel.layer.cornerRadius = 7
        dispensaryLabel.numberOfLines = 4
        dispensaryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        dispensaryLabel.textAlignment = .center
        view.addSubview(dispensaryLabel)
        dispensaryLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(90)
            make.top.equalTo(tagsLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
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
            make.width.equalTo(view.snp.width).multipliedBy(0.95)
            make.height.equalTo(view.snp.height).multipliedBy(0.35)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.bottom.equalTo(view.snp.bottomMargin).inset(5)
            
        }
        addDispensaryCoordinates()
        zoomIn()
    }
    
    private func fetchImageView() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = URL(string: (self?.productURL)!) else {
                return
            }
            
            ///If the image is already in the cache then don't make the request and update the imageView to what's in the cache
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                ///Updates to the UI run on the main thread
                DispatchQueue.main.async { [weak self] in
                    self?.strainView.image = imageFromCache
                }
                
            } else {
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                ///Resize the image to optimize memory usage and insert it into the cache
                var weedmapsImageToCache = UIImage(data: data)?.resizeImage(newSize: CGSize(width: 100, height: 100))
                imageCache.setObject(weedmapsImageToCache!, forKey: url as AnyObject)

                ///Updates to the UI occur on the main thread
                DispatchQueue.main.async { [weak self] in
                    self?.strainView.image = weedmapsImageToCache
                }
            }

            
        }


    }
    
    // MARK: Location Service Helper Methods
        
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
    
    private func beginUpdatingLocation() {
        mapView.showsUserLocation = true
        locationService?.locationManager.startUpdatingLocation()
    }
    
    private func zoomIn() {
        var zoomRect = MKMapRect.null;
        var currentCoordinate = MKMapPoint((locationService?.currentCoordinate)!)
        var currentLatLon = CLLocationCoordinate2D(latitude: dispensaryLatitude, longitude: dispensaryLongitude)
        var currentPoint = MKMapPoint(currentLatLon)
        var myLocationPointRect = MKMapRect(origin: currentCoordinate, size: MKMapSize(width: 0.0, height: 0.0))
        var currentDestinationPointRect = MKMapRect(origin: currentPoint, size: MKMapSize(width: 0.0, height: 0.0))

        zoomRect = currentDestinationPointRect
        zoomRect = zoomRect.union(myLocationPointRect)
        mapView.setVisibleMapRect(zoomRect, animated: true)
    }
    
    

}
