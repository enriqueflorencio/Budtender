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
    
    // MARK: Private Variables
    
    private var resultCollectionView: UICollectionView!
    private var matchesDictionary : [Int : [Herb]] = [:]
    private var locationService: LocationService?
    private var userTags = [String]()
    private var dispensarySlugs = [slugs]()
    private var herbs = [Herb]()
    
    // MARK: Constructor Methods
    
    init(locationService: LocationService?, userTags: [String]) {
        self.locationService = locationService
        self.userTags = userTags
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View Controller Life Cycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureConstraints()
        beginUpdatingLocation()
        
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    public override func didReceiveMemoryWarning() {
        imageCache.removeAllObjects()
    }
    
    // MARK: UI Methods
    
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
        displayLoadingScreen()
        
    }
    
    private func displayLoadingScreen() {
        
        SVProgressHUD.show()
    }
    
    private func dismissLoadingScreen() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: Parsing Methods
    
    private func fetchJSON(_ dispensaryString: String, _ address: String, _ latitude: Double, _ longitude: Double) {
        let weedmapsURLString = "https://api-g.weedmaps.com/discovery/v1/listings/dispensaries/\(dispensaryString)/menu_items?page=1&page_size=150&limit=150"
        if let url = URL(string: weedmapsURLString) {
            if let data = try? Data(contentsOf: url) {
                parse(data, dispensaryString, address, latitude, longitude)
            }
        }

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
        
        
    }
        
    private func fetchDispensaries(callback: @escaping ([Int : [Herb]?]) -> Void) {
        
        displayLoadingScreen()
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
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            let nearestDispensaryURL = "https://api-g.weedmaps.com/discovery/v1/listings?filter[bounding_box]=\(bottomLong),\(bottomLat),\(topLong),\(topLat)&filter[plural_types][]=doctors&filter[plural_types][]=dispensaries&filter[plural_types][]=deliveries&size=100"
            if let url = URL(string: nearestDispensaryURL) {
                if let data = try? Data(contentsOf: url) {
                    self?.parseDispensaries(data)
                }
            }
            callback(self!.matchesDictionary)
        }
            
        
    }
    
    private func parse(_ json: Data, _ dispensaryString: String, _ address: String, _ latitude: Double, _ longitude: Double) {
        let decoder = JSONDecoder()

        if var jsonTags = try? decoder.decode(DispensaryDetails.self, from: json) {
            var weedData = jsonTags.data
            var tags = weedData.menu_items
            var matches = 0
            
            for tag in tags {
                if let arr = tag.tags {
                    for elm in arr {
                        ///We're still in the background thread
                        if(userTags.contains(elm.name)) {
                            matches += 1
                        }
                        
                    }
                        let newDispensaryString = dispensaryString.replacingOccurrences(of: "-", with: " ")
                        var newHerb = Herb(name: tag.name, tags: arr, slug: newDispensaryString, latitude: latitude, longitude: longitude, address: address, locationService: locationService!, herbImageURL: (tag.avatar_image?.original_url)!)
                        
                        matchesDictionary[matches, default: []].append(newHerb)
                    
                }
                matches = 0

            }
        }

    }
    
    // MARK: Location Services Methods
        
    private func beginUpdatingLocation() {
        locationService?.delegate = self
        locationService?.locationManager.startUpdatingLocation()
    }
    
    // MARK: Location Services Delegation Methods
    
    public func queryDispensaries() {
        fetchDispensaries() { completedDictionary in
            self.matchingAlgorithm(completedDictionary)
            DispatchQueue.main.async { [weak self] in
                self!.resultCollectionView.reloadData()
                self!.dismissLoadingScreen()
            }
            
        }
    }
    
    private func matchingAlgorithm(_ completedDictionary: [Int : [Herb]?]) {
        for i in (0 ..< 9).reversed() {
            if let matchesDict = matchesDictionary[i] {
                for product in matchesDict {
                    herbs.append(product)
                }
            }
            
        }
        
    }
    
    public func notifyStatus(status: CLAuthorizationStatus) {}
    
    // MARK: Collection View Delegation Methods
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return herbs.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ResultCollectionViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        cell.budLabel.text = herbs[indexPath.row].name
        cell.imageURL = herbs[indexPath.row].herbImageURL
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
        locationService?.locationManager.stopMonitoringSignificantLocationChanges()
        locationService?.locationManager.stopUpdatingLocation()
        
        let dispensaryViewController = DispensaryLocationViewController(locationService: locationService , strain: selectedStrain.name, dispensary: selectedStrain.slug, tags: selectedTags, address: selectedStrain.address, dispensaryLatitude: selectedStrain.latitude, dispensaryLongitude: selectedStrain.longitude, productURL: selectedStrain.herbImageURL)
        navigationController?.pushViewController(dispensaryViewController, animated: true)
    }

}

let imageCache = NSCache<AnyObject, AnyObject>()
