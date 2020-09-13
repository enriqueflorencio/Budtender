//
//  QuizViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/14/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit
import SVProgressHUD

public class QuizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuizCellDelegate {
    public func didChooseAnswer(buttonIndex: Int) {
        let centerindex = getCenterIndex()
        guard let index = centerindex else {
            
            return
        }
        
        if(buttonIndex == 0) {
            userTags.append(questionsArray[index.item].weedmapsTag)
        }
        
        questionsArray[index.item].buttonTag = buttonIndex
        
        questionsArray[index.item].isAnswered = true
        currentQuestionNumber += 1
        quizCollectionView.reloadItems(at: [index])
        
    }
    
    private func getCenterIndex() -> IndexPath? {
        let center = self.view.convert(self.quizCollectionView.center, to: self.quizCollectionView)
        let index = quizCollectionView.indexPathForItem(at: center)
        return index
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? QuizCollectionViewCell else {
            fatalError("Could not dequeue cell")
        }
        cell.question = questionsArray[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    private var quizCollectionView: UICollectionView!
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    private var questionsArray = [Question]()
    private var currentQuestionNumber = 0
    private var locationService: LocationService?
    private var userTags = [String]()
    private var screenRect: UILayoutGuide?
    
    init(locationService: LocationService?) {
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print(view.frame.height)
        configureView()
        configureButtons()
        configureCollectionView()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        screenRect = view.safeAreaLayoutGuide
        
        
    }
    
    @objc func previousAction(_ sender: UIButton) {
        sender.pulsate()
        var contentOffset = CGFloat(floor(self.quizCollectionView.contentOffset.x - self.quizCollectionView.bounds.size.width))
        self.moveToFrame(contentOffset)
    }
    
    @objc func nextAction(_ sender: UIButton) {
        sender.pulsate()
        
        if(currentQuestionNumber == questionsArray.count) {
            
            locationService?.delegate = nil
            let resultViewController = ResultViewController(locationService: locationService, userTags: userTags)
            navigationController?.pushViewController(resultViewController, animated: true)
            
            return
        }
        var contentOffset = CGFloat(floor(self.quizCollectionView.contentOffset.x + self.quizCollectionView.bounds.size.width))
        self.moveToFrame(contentOffset)
    }
    
    
    
    private func moveToFrame(_ contentOffset: CGFloat) {
        let frame: CGRect = CGRect(x: contentOffset, y: self.quizCollectionView.contentOffset.y, width: self.quizCollectionView.frame.width, height: self.quizCollectionView.frame.height)
        print(self.quizCollectionView.frame.height)
        self.quizCollectionView.scrollRectToVisible(frame, animated: true)
    }
    
    
    private func configureButtons() {
        previousButton.setTitle("< Previous", for: .normal)
        previousButton.setTitleColor(UIColor.white, for: .normal)
        previousButton.backgroundColor = UIColor.orange
        previousButton.addTarget(self, action: #selector(previousAction), for: .touchUpInside)
        
        nextButton.setTitle("Next >", for: .normal)
        nextButton.setTitleColor(UIColor.white, for: .normal)
        nextButton.backgroundColor = UIColor.purple
        nextButton.addTarget(self, action: #selector(nextAction), for: .touchUpInside)
    }
    
    private func configureView() {
        title = "Home"
        // view.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: view.frame.width, height: view.frame.height)
        layout.estimatedItemSize = .zero
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        
        quizCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        quizCollectionView.delegate = self
        quizCollectionView.dataSource = self
        quizCollectionView.register(QuizCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        quizCollectionView.showsHorizontalScrollIndicator = false
        quizCollectionView.translatesAutoresizingMaskIntoConstraints = false
        quizCollectionView.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
        quizCollectionView.isPagingEnabled = true
        view.addSubview(quizCollectionView)
        setupQuestions()
        setupViews()
    }
    
    private func setupQuestions() {
        let question1 = Question(questionText: "Are you interested in feeling more energetic?", weedmapsTag: "Energetic", isAnswered: false, buttonTag: nil)
        let question2 = Question(questionText: "Are you looking to be more creative?", weedmapsTag: "Creative", isAnswered: false, buttonTag: nil)
        let question3 = Question(questionText: "Are you looking for something that will help uplift your mood?", weedmapsTag: "Uplifted", isAnswered: false, buttonTag: nil)
        let question4 = Question(questionText: "Are you interested in being more talkative or open?", weedmapsTag: "Earthy", isAnswered: false, buttonTag: nil)
        let question5 = Question(questionText: "Would you like to be more relaxed?", weedmapsTag: "Relaxed", isAnswered: false, buttonTag: nil)
        let question6 = Question(questionText: "Do you desire to feel euphoric?", weedmapsTag: "Euphoric", isAnswered: false, buttonTag: nil)
        let question7 = Question(questionText: "Are you looking for something that will help you have a good night's rest?", weedmapsTag: "Sleepy", isAnswered: false, buttonTag: nil)
        let question8 = Question(questionText: "Would you like to be more giggly or amused?", weedmapsTag: "Giggly", isAnswered: false, buttonTag: nil)
        
        questionsArray = [question1, question2, question3, question4, question5, question6, question7, question8]
    }
    
    private func setupViews() {
        quizCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(previousButton)
        previousButton.snp.makeConstraints { (make) in
            make.height.equalTo(50)
            make.width.equalTo(view.snp.width).multipliedBy(0.5)
            make.left.equalTo(view.snp.left)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(previousButton.snp.height)
            make.width.equalTo(previousButton.snp.width)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
    }

}
