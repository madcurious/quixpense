//
//  SummaryVC.swift
//  Spare
//
//  Created by Matt Quiros on 02/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private enum ViewID: String {
    case Banner = "Banner"
    case Cell = "Cell"
}

class SummaryVC: UIViewController {
    
    var summary: Summary
    var totals: [Category : NSDecimalNumber]!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.registerNib(__SVCBannerView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Banner.rawValue)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.totals = summary.categoryTotals
    }
    
}

extension SummaryVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        guard let categories = self.summary.categories
//            else {
//                return 0
//        }
//        return categories.count
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        fatalError()
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let bannerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Banner.rawValue, forIndexPath: indexPath) as? __SVCBannerView,
            let expenses = self.summary.expenses
            else {
                fatalError()
        }
        
//        bannerView.totalLabel.text = String(format: "$ %.2f",
//                                            expenses.map({ $0.amount ?? NSDecimalNumber(integer: 0) })
//                                                .reduce(NSDecimalNumber(integer: 0), combine: { (runningTotal, next) in
//                                                    return runningTotal.decimalNumberByAdding(next)
//                                                }))
        
        bannerView.totalLabel.text = String(format: "$ %.2f",
                                            expenses.map({ $0.amount ?? NSDecimalNumber(integer: 0) })
                                                .reduce(NSDecimalNumber(integer: 0), combine: +))
        
        return bannerView
    }
    
}

extension SummaryVC: UICollectionViewDelegate {}

extension SummaryVC: UICollectionViewDelegateFlowLayout {
    
    
    
}
