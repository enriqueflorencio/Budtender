//
//  ResultViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/21/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit
import CoreLocation
import SVProgressHUD

public class ResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, LocationServiceDelegate {
    public func queryDispensaries() {
        fetchDispensaries()
    }
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        
    }
    
    public func zoomToLatestLocation(coordinate: CLLocationCoordinate2D) {
        ///This is messing everything up. Change it to something else. The delegation is off for the location service manager
        
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return herbs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ResultCollectionViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        cell.budLabel.text = herbs[indexPath.row].name
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedStrain = herbs[indexPath.row]
        var selectedTags = [String]()
        for element in selectedStrain.tags {
            selectedTags.append(element.name)
        }
        locationService?.delegate = nil
        
        let dispensaryViewController = DispensaryLocationViewController(locationService: locationService , strain: selectedStrain.name, dispensary: selectedStrain.slug, tags: selectedTags, address: selectedStrain.address, dispensaryLatitude: selectedStrain.latitude, dispensaryLongitude: selectedStrain.longitude)
        navigationController?.pushViewController(dispensaryViewController, animated: true)
    }
    
    private var resultCollectionView: UICollectionView!
    private var locationService: LocationService?
    private var userTags = [String]()
    private var dispensarySlugs = [slugs]()
    private var herbs = [Herb]()
    
    init(locationService: LocationService?, userTags: [String]) {
        self.locationService = locationService
        self.userTags = userTags
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func fetchJSON(_ dispensaryString: String, _ address: String, _ latitude: Double, _ longitude: Double) {
        let weedmapsURLString = "https://api-g.weedmaps.com/discovery/v1/listings/dispensaries/\(dispensaryString)/menu_items?page=1&page_size=150&limit=150"
        if let url = URL(string: weedmapsURLString) {
            if let data = try? Data(contentsOf: url) {
                parse(data, dispensaryString, address, latitude, longitude)
            }
        }

    }
        
    private func fetchDispensaries() {
        
        guard let bottomLong = locationService?.getBottomLongitude() else {
            return
        }
            
        guard let bottomLat = locationService?.getBottomLatitude() else {
            return
        }
            
        guard let topLong = locationService?.getTopLongitude() else {
            return
        }
            
        guard let topLat = locationService?.getTopLatitude() else {
            return
        }
            
        let nearestDispensaryURL = "https://api-g.weedmaps.com/discovery/v1/listings?filter[bounding_box]=\(bottomLong),\(bottomLat),\(topLong),\(topLat)&filter[plural_types][]=doctors&filter[plural_types][]=dispensaries&filter[plural_types][]=deliveries&size=100"
        if let url = URL(string: nearestDispensaryURL) {
            if let data = try? Data(contentsOf: url) {
                print("HELLO")
                parseDispensaries(data)
            }
        }
    }
        
    private func beginUpdatingLocation() {
        locationService?.delegate = self
        locationService?.locationManager.startUpdatingLocation()
    }
        
    private func parseDispensaries(_ json: Data) {
        let decoder = JSONDecoder()
            
        if let jsonDispensaries = try? decoder.decode(Dispensary.self, from: json) {
            var slugData = jsonDispensaries.data
            var listings = slugData.listings
            for elm in listings {
                dispensarySlugs.append(elm)
            }
        }
        
        for slug in dispensarySlugs {
            fetchJSON(slug.slug!, slug.address!, slug.latitude!, slug.longitude!)
        }
        
        SVProgressHUD.dismiss()
    }
        
    private func parse(_ json: Data, _ dispensaryString: String, _ address: String, _ latitude: Double, _ longitude: Double) {
        let decoder = JSONDecoder()

        /// Use GCD later
        if let jsonTags = try? decoder.decode(WeedData.self, from: json) {
            var weedData = jsonTags.data
            var tags = weedData.menu_items
            
            for tag in tags {
                //print(tag.name)
                if let arr = tag.tags {
                    for elm in arr {
                        /// for the offficial method we need to check against the tags in our array
            
                        if(userTags.contains(elm.name)) {
                            let newDispensaryString = dispensaryString.replacingOccurrences(of: "-", with: " ")
                            let newHerb = Herb(name: tag.name, tags: arr, slug: newDispensaryString, latitude: latitude, longitude: longitude, address: address, locationService: locationService!)
                            herbs.append(newHerb)
                            break
                        }
                    }
                }

            }
        }
        
        resultCollectionView.reloadData()

    }
    

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureCollectionView()
        configureConstraints()
        beginUpdatingLocation()
        
        
        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        title = "Results"
        view.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 160, height: 160)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        resultCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.showsVerticalScrollIndicator = true
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        resultCollectionView.backgroundColor = UIColor.white
        view.addSubview(resultCollectionView)
    }
    
    private func configureConstraints() {
        resultCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

}
