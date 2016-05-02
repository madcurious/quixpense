//
//  CardVC.swift
//  Spare
//
//  Created by Matt Quiros on 29/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class CardVC: UIViewController {
    
    let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var data: [[String : AnyObject]]? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.view.addSubviewAndFill(self.collectionView)
    }
    
}

extension CardVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = self.data
            else {
                return 0
        }
        return data.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return UICollectionViewCell(frame: CGRectZero)
    }
    
}

extension CardVC: UICollectionViewDelegate {
    
    
    
}

extension CardVC: UICollectionViewDelegateFlowLayout {
    
    
    
}
