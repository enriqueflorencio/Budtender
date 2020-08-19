//
//  QuizCollectionViewCell.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/18/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit

class QuizCollectionViewCell: UICollectionViewCell {
    private var trueButton = UIButton()
    private var falseButton = UIButton()
    private let labelQuestion = UILabel()
    
    private var buttonsArray = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    private func configureQuestion() {
        labelQuestion.text = "This is a question?"
        labelQuestion.textColor = UIColor.black
        labelQuestion.textAlignment = .center
        labelQuestion.frame.size = CGSize(width: 50, height: 50)
        labelQuestion.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        labelQuestion.numberOfLines = 4
    }
    
    private func configureViews() {
        addSubview(labelQuestion)
        labelQuestion.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
        }
    }
    
    private func getButton(_ tag: Int) -> UIButton {
        let btn = UIButton()
        btn.tag = tag
        btn.setTitle("Option", for: .normal)
        btn.setTitleColor(UIColor.black, for: .normal)
        btn.backgroundColor = UIColor.white
        btn.layer.borderWidth = 1
        btn.layer.cornerRadius = 5
        btn.layer.borderColor = UIColor.darkGray.cgColor
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }
    
}
