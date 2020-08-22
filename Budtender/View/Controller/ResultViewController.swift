//
//  ResultViewController.swift
//  Budtender
//
//  Created by Enrique Florencio on 8/21/20.
//  Copyright © 2020 Enrique Florencio. All rights reserved.
//

import UIKit
import SnapKit

class ResultViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ResultCollectionViewCell else {
            fatalError("Could not dequeue reusable cell")
        }
        
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    private var resultCollectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureConstraints()
        // Do any additional setup after loading the view.
    }
    
    private func configureCollectionView() {
        title = "Results"
        view.backgroundColor = UIColor.white
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 145, height: 145)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        resultCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height), collectionViewLayout: layout)
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.showsVerticalScrollIndicator = true
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        resultCollectionView.backgroundColor = UIColor.white
        view.addSubview(resultCollectionView)
    }
    
    private func configureConstraints() {
        resultCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
    }

}
