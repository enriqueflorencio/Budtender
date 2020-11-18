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

///The root view controller that prompts a user to give us access to their location.
public class SelectionViewController: UIViewController, LocationServiceDelegate {
    
    // MARK: Private Variables
    
    private let animationView = AnimationView()
    private let starterText = UILabel()
    private let getStartedBtn = UIButton()
    private var locationService: LocationService?
    
    // MARK: View Controller Life Cycle Methods

    public override func viewDidLoad() {
        super.viewDidLoad()
        ///Configure the layout
        configureText()
        setupAnimation()
        configureButton()
        checkLocationServices()
        
    }
    
    // MARK: UI Methods
    
    ///Setup the navigation title and label that prompts the user to take the quiz
    private func configureText() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = .white
        starterText.text = "Get recommendations based on your needs!"
        starterText.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        starterText.numberOfLines = 2
        starterText.textAlignment = .center
        view.addSubview(starterText)
        starterText.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.snp.height).multipliedBy(0.10)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }
        
    }
    
    ///Setup a map animation with the help of the lottie framework
    private func setupAnimation() {
        animationView.animation = Animation.named("map")
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).multipliedBy(0.8)
            make.height.equalTo(view.snp.height).multipliedBy(0.3)
            make.top.equalTo(starterText.snp.bottom).offset(40)
            make.centerX.equalTo(view.snp.centerX)
        }


        animationView.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.6
        animationView.loopMode = .loop
        animationView.play()

    }
    
    ///Configure the constraints and layout of the button that will allow the user to move onto the quiz view controller
    private func configureButton() {
        getStartedBtn.layer.cornerRadius = 20
        getStartedBtn.setTitle("Take Quiz", for: .normal)
        getStartedBtn.backgroundColor = .green
        getStartedBtn.addTarget(self, action: #selector(takeQuiz), for: .touchUpInside)
        view.addSubview(getStartedBtn)
        getStartedBtn.snp.makeConstraints { (make) in
            make.width.equalTo(view.snp.width).multipliedBy(0.9)
            make.height.equalTo(view.snp.height).multipliedBy(0.15)
            make.bottom.equalTo(view.snp.bottom).inset(45)
            make.centerX.equalTo(view.snp.centerX)
        }
    }
    
    ///Call this function to present an alert controller to the user if they denied us from using their location
    public func presentAlertController() {
        let ac = UIAlertController(title: "WARNING:", message: "Budtender neeeds access to your location in order to deliver a satisfying experience. Please change your settings to grant us access to your location.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    // MARK: Location Services Methods
    
    private func checkLocationServices() {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationService = LocationService(locationManager: locationManager)
        locationService?.setupLocationServices()
        locationService?.delegate = self
    }
    
    // MARK: Objective-C Methods
    
    ///Move on to the quiz view controller as soon as this button is tapped
    @objc func takeQuiz(sender: UIButton!) {
        locationService?.delegate = nil
        sender.pulsate()
        let quizViewController = QuizViewController(locationService: locationService)
        navigationController?.pushViewController(quizViewController, animated: true)

    }
    
    // MARK: Delegation Methods
    
    public func queryDispensaries() {}
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        ///If the user has denied us from using their location, don't allow them to take the quiz until they change their privacy settings
        if(status == .denied) {
            presentAlertController()
            getStartedBtn.isEnabled = false
        }
    }

}
