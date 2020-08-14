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

class SelectionViewController: UIViewController {
    
    private let animationView = AnimationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ///Configure the layout
        configureLayout()
        setupAnimation()
    }
    
    private func configureLayout() {
        title = "Budtender"
        view.backgroundColor = .white
        view.layoutMargins = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
    }
    
    private func setupAnimation() {
        animationView.animation = Animation.named("forest")
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.snp.makeConstraints { (make) in
            make.width.equalTo(170)
            make.height.equalTo(170)
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        animationView.backgroundColor = .white
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
    }

}
