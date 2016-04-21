//
//  HomeVC.swift
//  Spare
//
//  Created by Matt Quiros on 20/04/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private let kViewID = "kViewID"

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
//        collectionView.pagingEnabled = true
        collectionView.registerNib(__HVCCardCell.nib(), forCellWithReuseIdentifier: kViewID)
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

extension HomeVC: UICollectionViewDelegate {}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = self.view.bounds.size
        size.width = size.width - 40
        return size
    }
    
}
