//
//  ResultCollectionViewCell.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/21/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit

///Collection View Cell that will be used to display recommendations to the user
public class ResultCollectionViewCell: UICollectionViewCell {
    // MARK: UI Elements
    ///Image view that will display a default image of an animated cannabis plant
    public var budimageView = UIImageView()
    ///Label that will display the name of the product that was retrieved from the weedmaps API.
    public var budLabel = UILabel()
    
    public var imageURL: String? {
        didSet {
            configureImageView()
            configureViews()
        }
    }
    
    // MARK: Constructor Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBud()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        budimageView.image = nil
        budLabel.text = nil
    }
    
    // MARK: UI Methods For Setting Up Cells
    
    ///This function configures the label that will display the name of the product
    private func configureBud() {
        budLabel.textColor = UIColor.black
        budLabel.textAlignment = .center
        budLabel.frame.size = CGSize(width: 145, height: 22)
        budLabel.font = UIFont(name: "HelveticaNeue-Thin", size: 11.0)
        budLabel.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        budLabel.layer.borderWidth = 2
        budLabel.layer.cornerRadius = 3
        budLabel.layer.cornerRadius = 7
        budLabel.numberOfLines = 4
    }
    
    ///This function will configure the constraints for each UI element inside of the cell with the help of SnapKit.
    private func configureViews() {
        self.backgroundColor = UIColor.white
        
        //budimageView.image = UIImage(named: "cannabis")
        budimageView.contentMode = .scaleAspectFit
        addSubview(budimageView)
        budimageView.snp.makeConstraints { (make) in
            make.width.equalTo(145)
            make.height.equalTo(120)
            make.top.equalTo(snp.top)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
        }
        
        addSubview(budLabel)
        budLabel.snp.makeConstraints { (make) in
            make.top.equalTo(budimageView.snp.bottom)
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.bottom.equalTo(snp.bottom)
        }
    }
    
    private func configureImageView() {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let url = URL(string: (self?.imageURL!)!) else {
                return
            }
            
            if let imageFromCache = imageCache.object(forKey: url as AnyObject) as? UIImage {
                DispatchQueue.main.async { [weak self] in
                    self?.budimageView.image = imageFromCache
                }
                
            } else {
                guard let data = try? Data(contentsOf: url) else {
                    return
                }
                
                var imageToCache = UIImage(data: data)?.resizeImage(newSize: CGSize(width: 100, height: 100))
                imageCache.setObject(imageToCache!, forKey: url as AnyObject)
                DispatchQueue.main.async { [weak self] in
                    self?.budimageView.image = imageToCache
                }
            }
            
            
        }
        
    }

}
