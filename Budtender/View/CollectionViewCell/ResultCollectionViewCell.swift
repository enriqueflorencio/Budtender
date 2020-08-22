//
//  ResultCollectionViewCell.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/21/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit

class ResultCollectionViewCell: UICollectionViewCell {
    
    private var budimageView = UIImageView()
    private var budLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    }
}
