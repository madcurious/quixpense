//
//  ExpenseListVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

class ExpenseListVC: UIViewController {
    
    let category: Category
    let startDate: NSDate
    let endDate: NSDate
    let layoutManager: UICollectionViewLayout
    let collectionView: UICollectionView
    
    init(category: Category, startDate: NSDate, endDate: NSDate) {
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        
        self.layoutManager = UICollectionViewFlowLayout()
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layoutManager)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        self.collectionView.backgroundColor = Color.ExpenseListScreenBackgroundColor
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.backgroundColor = self.category.color
            navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
