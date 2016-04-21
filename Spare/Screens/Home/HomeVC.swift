//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kViewID = "kViewID"

private let kStatusBarHeight = CGFloat(20)
private let kTopBottomInset = CGFloat(10)
private let kLeftRightInset = CGFloat(20)
private let kItemSpacing = CGFloat(10)

class HomeVC: BaseVC {
    
    var customView = __HVCView.instantiateFromNib() as __HVCView
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Home"
        self.tabBarItem.title = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView = self.customView.collectionView
        collectionView.registerClass(__HVCCardCell.self, forCellWithReuseIdentifier: kViewID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = {
            let layoutManager = UICollectionViewFlowLayout()
            layoutManager.scrollDirection = .Horizontal
            return layoutManager
        }()
    }
    
}

extension HomeVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(kViewID, forIndexPath: indexPath) as? __HVCCardCell
            else {
                fatalError()
        }
        return cell
    }
    
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kItemSpacing
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kTopBottomInset, left: kLeftRightInset, bottom: kTopBottomInset, right: kLeftRightInset)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = collectionView.bounds.size
        size.width = size.width - (kLeftRightInset * 2)
        size.height = size.height - (kStatusBarHeight + kTopBottomInset * 2)
        return size
    }
    
}

extension HomeVC: UICollectionViewDelegate {

    // Needed to prevent collection view cells from highlighting the internal table view.
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
