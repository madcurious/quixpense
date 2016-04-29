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
        
        self.view.addSubviewAndFill(self.collectionView)
    }
    
}