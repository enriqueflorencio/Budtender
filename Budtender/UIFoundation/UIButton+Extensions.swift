//
//  UIButton+Extensions.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/31/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import UIKit

///Extension for adding an animated effect to a UIButton.
extension UIButton {
    // MARK: Button Animations
    public func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.1
        pulse.fromValue = 0.97
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = 2
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
}
