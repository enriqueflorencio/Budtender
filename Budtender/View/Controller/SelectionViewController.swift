//
//  SelectionViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/13/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import Lottie
import SnapKit
import CoreLocation

public class SelectionViewController: UIViewController, LocationServiceDelegate {
    public func zoomToLatestLocation(coordinate: CLLocationCoordinate2D) {
        
    }
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        if(status == .denied) {
            presentAlertController()
        }
    }
    
    private let animationView = AnimationView()
    private let starterText = UILabel()
    private let getStartedBtn = UIButton()
    private var locationService: LocationService?
    //private let nearestDispensaryURL = "https://api-g.weedmaps.com/discovery/v1/listings?filter[bounding_box]=\(),\(),\(),\()&filter[plural_types][]=doctors&filter[plural_types][]=dispensaries&filter[plural_types][]=deliveries&size=100"
    private var tags = [Tag]()

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Fetch JSON from api
        //fetchJSON("blue-fire")
//        fetchJSON("fire-leaf-dispensary-stockyard")
//        fetchJSON("buddha-company-2")
//        fetchJSON("bmc-2")
//        fetchJSON("svc-home-of-the-louie-xiii")
//        fetchJSON("exhale-med-center")
//        fetchJSON("scsa-south-coast-safe-access")
//        fetchJSON("concentrate-leader")
//        fetchJSON("og-dispensary")
//        fetchJSON("highnotewest")
//        fetchJSON("happy-leaf-la")
//        print("FIRELEAF")
//        fetchJSON("fire-leaf-dispensary-stockyard")
        
        ///Configure the layout
        configureLayout()
        setupAnimation()
        checkLocationServices()
    }
    
    private func fetchJSON(_ dispensaryString: String) {
        let weedmapsURLString = "https://api-g.weedmaps.com/discovery/v1/listings/dispensaries/\(dispensaryString)/menu_items?page=1&page_size=150&limit=150"
        if let url = URL(string: weedmapsURLString) {
            if let data = try? Data(contentsOf: url) {
                parse(data)
            }
        }
        
    }
    
    private func parse(_ json: Data) {
        let decoder = JSONDecoder()
        
        /// Use GCD later
        if let jsonTags = try? decoder.decode(WeedData.self, from: json) {
            var weedData = jsonTags.data
            tags = weedData.menu_items
        }
        
        for tag in tags {
            
            //print(tag.name)
            if let arr = tag.tags {
                for elm in arr {
                    //print(elm.name)
                    if(elm.name == "Euphoric") {
                        print(tag.name)
                    }
                }
            }

        }
        
    }
    
    private func checkLocationServices() {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationService = LocationService(locationManager: locationManager)
        locationService?.setupLocationServices()
        locationService?.delegate = self
    }
    
    private func configureLayout() {
        title = "Budtender"
        view.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
        
        navigationController?.navigationBar.barTintColor = .white
        view.layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
        starterText.text = "Get recommendations based on your needs!"
        starterText.frame.size = CGSize(width: 50, height: 50)
        starterText.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        starterText.textAlignment = .center
        view.addSubview(starterText)
        starterText.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top).inset(5)
            make.bottom.equalTo(-400)
            make.trailing.equalTo(5)
            make.leading.equalTo(-5)
        }
        
        getStartedBtn.frame.size = CGSize(width: 5, height: 5)
        getStartedBtn.layer.cornerRadius = 5
        getStartedBtn.setTitle("Take Quiz", for: .normal)
        getStartedBtn.backgroundColor = .green
        getStartedBtn.addTarget(self, action: #selector(takeQuiz), for: .touchUpInside)
        view.addSubview(getStartedBtn)
        getStartedBtn.snp.makeConstraints { (make) in
            make.top.equalTo(550)
            make.bottom.equalTo(-30)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
        }
        
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("map")
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        
        animationView.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.6
        animationView.loopMode = .loop
        animationView.play()
        
    }
    
    @objc func takeQuiz(sender: UIButton!) {
        locationService?.delegate = nil
        sender.pulsate()
        let quizViewController = QuizViewController(locationService: locationService)
        navigationController?.pushViewController(quizViewController, animated: true)

//        let dispensaryViewController = DispensaryLocationViewController(locationService: locationService , strain: "OG Kush", dispensary: "Happy Leaf LA", tags: ["Happy", "Relaxed"], address: "2131 Westwood Blvd, Los Angeles, CA 90025")
//        navigationController?.pushViewController(dispensaryViewController, animated: true)
    }
    
    public func presentAlertController() {
        let ac = UIAlertController(title: "WARNING:", message: "Budtender neeeds access to your location in order to deliver a satisfying experience. Please change your settings to grant us access to your location.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }

}


