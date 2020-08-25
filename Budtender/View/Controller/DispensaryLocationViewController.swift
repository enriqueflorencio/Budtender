//
//  DispensaryLocationViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/23/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import MapKit
import SnapKit

public class DispensaryLocationViewController: UIViewController, MKMapViewDelegate {
    
    private let strain: String
    private let dispensary: String
    private let tags: [String]
    private let address: String
    
    public init(strain: String, dispensary: String, tags: [String], address: String) {
        self.strain = strain
        self.dispensary = dispensary
        self.tags = tags
        self.address = address
        super.init(nibName: nil, bundle: nil)
    }
    
    private let strainView = UIImageView()
    private let strainLabel = UILabel()
    private let dispensaryLabel = UILabel()
    private var tagsLabel = UILabel()
    private let mapView = MKMapView()
    private var locationService: LocationService?
    
    
    
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
    
    private func configureViews() {
        title = strain
        view.backgroundColor = UIColor.white
        
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
        strainLabel.text = strain
        strainLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        strainLabel.layer.borderWidth = 2
        strainLabel.layer.cornerRadius = 3
        strainLabel.layer.cornerRadius = 7
        strainLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        strainLabel.textAlignment = .center
        view.addSubview(strainLabel)
        strainLabel.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(45)
            make.top.equalTo(strainView.snp.top).inset(35)
            make.left.equalTo(strainView.snp.right).offset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
        tagsLabel.text = " Tags: "
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
        tagsLabel.layer.cornerRadius = 7
        tagsLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        tagsLabel.textAlignment = .left
        view.addSubview(tagsLabel)
        tagsLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.top.equalTo(strainView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
        dispensaryLabel.text = " Dispensary: "
        dispensaryLabel.text! += dispensary
        dispensaryLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        dispensaryLabel.layer.borderWidth = 2
        dispensaryLabel.layer.cornerRadius = 3
        dispensaryLabel.layer.cornerRadius = 7
        dispensaryLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 14.0)
        dispensaryLabel.textAlignment = .left
        view.addSubview(dispensaryLabel)
        dispensaryLabel.snp.makeConstraints { (make) in
            make.width.equalTo(300)
            make.height.equalTo(80)
            make.top.equalTo(tagsLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
        }
    }
    
    private func configureMapView() {
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.width.equalTo(340)
            make.height.equalTo(250)
            make.left.equalTo(view.snp.left).inset(10)
            make.right.equalTo(view.snp.right).inset(10)
            make.top.equalTo(dispensaryLabel.snp.bottom).offset(15)
            
        }
    }

}
