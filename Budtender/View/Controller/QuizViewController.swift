//
//  QuizViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/14/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit

public class QuizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questionsArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? QuizCollectionViewCell else {
            fatalError("Could not dequeue cell")
        }
        cell.question = questionsArray[indexPath.row]
        
        return cell
    }
    
    private var quizCollectionView: UICollectionView!
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    private var questionsArray = [Question]()
    private var currentQuestionNumber = 1
    private var locationService: LocationService?
    
    init(locationService: LocationService?) {
        self.locationService = locationService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureButtons()
        configureCollectionView()
    }
    
    @objc func previousAction(_ sender: UIButton) {
        sender.pulsate()
        var contentOffset = CGFloat(floor(self.quizCollectionView.contentOffset.x - self.quizCollectionView.bounds.size.width))
        self.moveToFrame(contentOffset)
    }
    
    @objc func nextAction(_ sender: UIButton) {
        sender.pulsate()
        
        if(currentQuestionNumber == questionsArray.count) {
            let resultViewController = ResultViewController(locationService: locationService)
            navigationController?.pushViewController(resultViewController, animated: true)
            
            return
        }
        var contentOffset = CGFloat(floor(self.quizCollectionView.contentOffset.x + self.quizCollectionView.bounds.size.width))
        self.moveToFrame(contentOffset)
    }
    
    private func moveToFrame(_ contentOffset: CGFloat) {
        let frame: CGRect = CGRect(x: contentOffset, y: self.quizCollectionView.contentOffset.y, width: self.quizCollectionView.frame.width, height: self.quizCollectionView.frame.height)
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
        let question1 = Question(questionText: "Do you feel stressed?", isAnswered: false)
        let question2 = Question(questionText: "Are you tired?", isAnswered: false)
        questionsArray = [question1, question2]
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
            make.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.height.equalTo(previousButton.snp.height)
            make.width.equalTo(previousButton.snp.width)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        
    }

}
