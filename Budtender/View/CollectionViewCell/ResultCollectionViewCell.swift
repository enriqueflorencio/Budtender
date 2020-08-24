//
//  ResultCollectionViewCell.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/21/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit

public class ResultCollectionViewCell: UICollectionViewCell {
    
    private var budimageView = UIImageView()
    private var budLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureBud()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureBud() {
        budLabel.text = "Blue Dream"
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
    
    private func configureViews() {
        self.backgroundColor = UIColor.white
        
        budimageView.image = UIImage(named: "cannabis")
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
}
