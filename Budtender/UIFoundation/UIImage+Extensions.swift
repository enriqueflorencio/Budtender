//
//  UIImage+Extensions.swift
//  Budtender
//
//  Created by Enrique Florencio on 9/10/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    public func resizeImage(newSize: CGSize) -> UIImage {
        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height
        
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
