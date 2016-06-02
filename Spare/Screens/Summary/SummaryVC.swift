//
//  SummaryVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class SummaryVC: UIViewController {
    
    var summary: Summary
    
    var collectionView: UICollectionView
    var layoutManager: UICollectionViewFlowLayout
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(summary: Summary) {
        self.summary = summary
        
        self.layoutManager = UICollectionViewFlowLayout()
        self.layoutManager.scrollDirection = .Vertical
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layoutManager)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    
    
}
