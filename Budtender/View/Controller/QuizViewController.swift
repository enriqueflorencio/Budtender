//
//  QuizViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/14/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit

class QuizViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var quizCollectionView: UICollectionView!
    private var questionsArray = [Question]()
    private var currentQuestionNumber = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
    }
    
    private func configureView() {
        title = "Home"
        view.backgroundColor = UIColor(red: 92/255, green: 197/255, blue: 243/255, alpha: 1.0)
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
        
    }

}
