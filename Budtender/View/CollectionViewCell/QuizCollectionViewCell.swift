//
//  QuizCollectionViewCell.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/18/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit

public class QuizCollectionViewCell: UICollectionViewCell {
    private var trueButton = UIButton()
    private var falseButton = UIButton()
    private let labelQuestion = UILabel()
    public var question: Question? {
        didSet {
            guard let unwrappedQuestion = question else {
                return
            }
            labelQuestion.text = unwrappedQuestion.questionText
            trueButton.setTitle("Yes", for: .normal)
            falseButton.setTitle("No", for: .normal)
        }
    }
    
    private var buttonsArray = [UIButton]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureQuestion()
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
    
    @objc func buttonOptionAction(sender: UIButton) {
        sender.pulsate()
    }
    
    public override func prepareForReuse() {
        trueButton.backgroundColor = UIColor.white
        falseButton.backgroundColor = UIColor.white
    }
    
    private func configureViews() {
        addSubview(labelQuestion)
        labelQuestion.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.centerX.equalTo(snp.centerX)
            make.width.height.equalTo(150)
        }
        
        trueButton = getButton(0)
        addSubview(trueButton)
        trueButton.snp.makeConstraints { (make) in
            make.top.equalTo(labelQuestion.snp.bottom).inset(20)
            make.right.equalTo(snp.centerX).inset(-10)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        trueButton.addTarget(self, action: #selector(buttonOptionAction), for: .touchUpInside)
        falseButton = getButton(1)
        addSubview(falseButton)
        falseButton.snp.makeConstraints { (make) in
            make.top.equalTo(trueButton.snp.top)
            make.left.equalTo(snp.centerX).inset(10)
            make.width.equalTo(150)
            make.height.equalTo(50)
        }
        falseButton.addTarget(self, action: #selector(buttonOptionAction), for: .touchUpInside)
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
