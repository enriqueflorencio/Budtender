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
    
    
    private let animationView = AnimationView()
    private let starterText = UILabel()
    private let getStartedBtn = UIButton()
    private var locationService: LocationService?

    public override func viewDidLoad() {
        super.viewDidLoad()
        ///Configure the layout
        configureText()
        setupAnimation()
        configureButton()
        checkLocationServices()
        
    }
    
    private func checkLocationServices() {
        let locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationService = LocationService(locationManager: locationManager)
        locationService?.setupLocationServices()
        locationService?.delegate = self
    }
    
    private func configureText() {
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
            make.top.equalTo(view.snp.topMargin).offset(40)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right).inset(20)
        }
        
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("map")
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.top.equalTo(starterText.snp.bottom).offset(70)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }


        animationView.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
        animationView.contentMode = .scaleAspectFit
        animationView.animationSpeed = 1.6
        animationView.loopMode = .loop
        animationView.play()

    }
    
    private func configureButton() {
        getStartedBtn.layer.cornerRadius = 5
        getStartedBtn.setTitle("Take Quiz", for: .normal)
        getStartedBtn.backgroundColor = .green
        getStartedBtn.addTarget(self, action: #selector(takeQuiz), for: .touchUpInside)
        view.addSubview(getStartedBtn)
        getStartedBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.bottom.equalTo(view.snp.bottomMargin).offset(20)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
    }
    
    @objc func takeQuiz(sender: UIButton!) {
        locationService?.delegate = nil
        sender.pulsate()
        let quizViewController = QuizViewController(locationService: locationService)
        navigationController?.pushViewController(quizViewController, animated: true)

    }
    
    public func presentAlertController() {
        let ac = UIAlertController(title: "WARNING:", message: "Budtender neeeds access to your location in order to deliver a satisfying experience. Please change your settings to grant us access to your location.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    public func queryDispensaries() {}
    
    public func notifyStatus(status: CLAuthorizationStatus) {
        if(status == .denied) {
            presentAlertController()
        }
    }

}
