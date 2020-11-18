//
//  QuizCollectionViewCell.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/18/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit

///Protocol that our quiz view controller will have to conform to in order to handle button clicks
public protocol QuizCellDelegate: class {
    func didChooseAnswer(buttonIndex: Int)
    func changeAnswer(buttonIndex: Int)
}

///Collection View Cell that will be used for each question in our quiz
public class QuizCollectionViewCell: UICollectionViewCell {
    // MARK: Private/Public UI Elements
    
    ///Buttons that user can tap on (yes/no)
    private var trueButton = UIButton()
    private var falseButton = UIButton()
    ///Label that will display our question to the user
    private let labelQuestion = UILabel()
    ///Stores our true/false buttons into an array
    private var buttonsArray = [UIButton]()
    ///This will be used to tell the cell how to behave when an answer got chosen
    public weak var delegate: QuizCellDelegate?
    
    ///In order for the cell to exist, we need to have a question ready for the user
    public var question: Question? {
        didSet {
            ///Safely unwrap it
            guard let unwrappedQuestion = question else {
                return
            }
            ///Setup the labels and buttons with texts and titles
            labelQuestion.text = unwrappedQuestion.questionText
            trueButton.setTitle("Yes", for: .normal)
            falseButton.setTitle("No", for: .normal)
            
            ///Set the button color to yellow to indicate that this question has been answered
            if unwrappedQuestion.isAnswered {
                buttonsArray[unwrappedQuestion.buttonTag!].backgroundColor = UIColor.yellow
            }
        }
    }
    
    // MARK: Constructors
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureQuestion()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not yet implemented")
    }
    
    // MARK: UI Methods For Setting Up Cells
    
    ///This function will setup a label with a question and configure the font size, frame size, etc.
    private func configureQuestion() {
        labelQuestion.text = "This is a question?"
        labelQuestion.textColor = UIColor.black
        labelQuestion.textAlignment = .center
        labelQuestion.frame.size = CGSize(width: 50, height: 50)
        labelQuestion.font = UIFont(name: "HelveticaNeue-Thin", size: 17.0)
        labelQuestion.numberOfLines = 4
    }
    
    ///This function will set the buttons background colors to white when they need to be reused
    public override func prepareForReuse() {
        trueButton.backgroundColor = UIColor.white
        falseButton.backgroundColor = UIColor.white
    }
    
    ///This function will configure the constraints for each UI element inside of the cell with the help of SnapKit.
    private func configureViews() {
        addSubview(labelQuestion)
        labelQuestion.snp.makeConstraints { (make) in
            make.top.equalTo(snp.top)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(snp.width).multipliedBy(0.55)
            make.height.equalTo(snp.height).multipliedBy(0.25)
        }
        
        trueButton = getButton(0)
        addSubview(trueButton)
        trueButton.snp.makeConstraints { (make) in
            make.top.equalTo(labelQuestion.snp.bottom).inset(25)
            make.width.equalTo(snp.width).multipliedBy(0.35)
            make.height.equalTo(snp.height).multipliedBy(0.09)
            make.left.equalTo(snp.left).inset(30)
            
        }
        trueButton.addTarget(self, action: #selector(buttonOptionAction), for: .touchUpInside)
        buttonsArray.append(trueButton)
        falseButton = getButton(1)
        addSubview(falseButton)
        falseButton.snp.makeConstraints { (make) in
            make.top.equalTo(labelQuestion.snp.bottom).inset(25)
            make.width.equalTo(snp.width).multipliedBy(0.35)
            make.height.equalTo(snp.height).multipliedBy(0.09)
            make.right.equalTo(snp.right).inset(30)
        }
        falseButton.addTarget(self, action: #selector(buttonOptionAction), for: .touchUpInside)
        buttonsArray.append(falseButton)
    }
    
    ///This function will deliver a button for whenever its called
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
    
    // MARK: Objective-C Functions
    
    ///This function handles a button click
    @objc func buttonOptionAction(sender: UIButton) {
        ///Animate the button click
        sender.pulsate()
        
        guard let unwrappedQuestion = question else {
            return
        }
        
        ///If the question hasn't been answered yet then the quiz view controller will handle it accordingly
        if(!unwrappedQuestion.isAnswered) {
            delegate?.didChooseAnswer(buttonIndex: sender.tag)
        } else {
            if(!(sender.tag == unwrappedQuestion.buttonTag!)) {
                if(unwrappedQuestion.buttonTag! == 0) {
                    question?.buttonTag = 1
                } else {
                    question?.buttonTag = 0
                }
                
                buttonsArray[unwrappedQuestion.buttonTag!].backgroundColor = UIColor.white
                buttonsArray[(question?.buttonTag)!].backgroundColor = UIColor.yellow
                print("sender: \(sender.tag)")
                delegate?.changeAnswer(buttonIndex: sender.tag)
            }
            
            
        }
    }
    
}
