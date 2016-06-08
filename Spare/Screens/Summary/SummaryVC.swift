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
    
    var summary: Summary? // Optional because the VC may be in a home screen cell whose initial state is undefined.
    var totals: [Category : NSDecimalNumber]?
    
    var collectionView: UICollectionView
    var layoutManager: UICollectionViewFlowLayout
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(summary: Summary?) {
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
        
        self.collectionView.backgroundColor = Color.White
        self.collectionView.registerNib(__SVCBannerView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Banner.rawValue)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.totals = summary?.categoryTotals
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
        guard let bannerView = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Banner.rawValue, forIndexPath: indexPath) as? __SVCBannerView
            else {
                fatalError()
        }
        
        bannerView.totalLabel.text = String(format: "$ %.2f", self.summary?.total ?? 0)
        bannerView.dateLabel.text = "Today"
        
        return bannerView
    }
    
}

extension SummaryVC: UICollectionViewDelegate {}

extension SummaryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, 150)
    }
    
}
