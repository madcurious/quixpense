//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private let kViewID = "kViewID"

//private let kStatusBarHeight = CGFloat(20)
private let kTopBottomInset = CGFloat(10)
private let kLeftRightInset = CGFloat(30)
private let kItemSpacing = CGFloat(10)

class HomeVC: MDStatefulViewController {
    
    var customView = __HVCView.instantiateFromNib() as __HVCView
    var viewHasAppeared = false
    
    var topInset: CGFloat {
        let statusBarHeight = UIApplication.sharedApplication().statusBarFrame.height
        if statusBarHeight > 20 {
            return kTopBottomInset
        }
        return statusBarHeight + kTopBottomInset
    }
    
    override var primaryView: UIView {
        return self.customView
    }
    
    override init() {
        super.init()
        self.title = "Home"
        self.tabBarItem.title = self.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        let collectionView = self.customView.collectionView
        collectionView.registerClass(__HVCCardCell.self, forCellWithReuseIdentifier: kViewID)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = __HVCLayoutManager()
        
        // The Home tab is not a true stateful view controller--it merely uses the class's
        // loading view so that the cards are properly scrolled to the last item before
        // the UI is shown to the user.
        self.showView(.Loading)
    }
    
    override func buildOperation() -> MDOperation? {
        return nil
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show the last item first.
        if self.viewHasAppeared == false {
            let collectionView = self.customView.collectionView
            let lastItem = collectionView.numberOfItemsInSection(0) - 1
            collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: lastItem, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
            collectionView.collectionViewLayout.invalidateLayout()
            self.showView(.Primary)
            self.viewHasAppeared = true
        }
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
        return UIEdgeInsets(top: self.topInset, left: kLeftRightInset, bottom: kTopBottomInset, right: kLeftRightInset)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = collectionView.bounds.size
        size.width = size.width - (kLeftRightInset * 2)
        size.height = size.height - (self.topInset + kTopBottomInset)
        return size
    }
    
}

extension HomeVC: UICollectionViewDelegate {

    // Needed to prevent collection view cells from highlighting the internal table view.
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

}
