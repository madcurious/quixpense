//
//  SummaryVC.swift
//  Spare
//
//  Created by Matt Quiros on 27/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case Graph = "Graph"
    case Cell = "Cell"
}

private let kCellInset = CGFloat(10)

class SummaryVC: UIViewController {
    
    var summary: Summary {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layoutManager = UICollectionViewFlowLayout()
        layoutManager.scrollDirection = .Vertical
        return UICollectionView(frame: CGRectZero, collectionViewLayout: layoutManager)
    }()
    
    lazy var zeroView = __SVCZeroView.instantiateFromNib()
    
    init(summary: Summary) {
        self.summary = summary
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = {[unowned self] in
            if self.summary.total == NSDecimalNumber(integer: 0) {
                return self.zeroView
            }
            return self.collectionView
        }()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.view {
        case self.collectionView:
            self.collectionView.backgroundView = UIImageView(image: UIImage.imageFromColor(Color.UniversalBackgroundColor))
            self.collectionView.alwaysBounceVertical = true
            self.collectionView.backgroundColor = Color.White
            self.collectionView.showsVerticalScrollIndicator = false
            
            self.collectionView.registerNib(__SVCGraphView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Graph.rawValue)
            self.collectionView.registerNib(__SVCCategoryCellBox.nib(), forCellWithReuseIdentifier: ViewID.Cell.rawValue)
            
            self.collectionView.dataSource = self
            self.collectionView.delegate = self
            
        default:
            self.zeroView.dateLabel.text = DateFormatter.displayTextForSummary(self.summary)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SummaryVC: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = glb_allCategories()
            else {
                return 0
        }
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.Cell.rawValue, forIndexPath: indexPath) as? __SVCCategoryCell
            else {
                fatalError()
        }
        cell.data = self.summary.data?[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        guard let graphView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.Graph.rawValue, forIndexPath: indexPath) as? __SVCGraphView
            where kind == UICollectionElementKindSectionHeader
            else {
                fatalError()
        }
        graphView.summary = self.summary
        return graphView
    }
    
}

extension SummaryVC: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let category = self.summary.data?[indexPath.item].0
            else {
                return
        }
        
        // Notify the container that a category cell has been tapped.
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.postNotificationName(
            Event.CategoryTappedInSummaryVC.rawValue,
            object: nil,
            userInfo: [
                "category" : category,
                "startDate" : self.summary.startDate,
                "endDate" : self.summary.endDate
            ])
    }
    
}

extension SummaryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width * 0.75)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.size.width - kCellInset * 2
        let dynamicHeight = __SVCCategoryCellBox.cellHeightForData(self.summary.data![indexPath.item], cellWidth: cellWidth)
        return CGSizeMake(cellWidth, dynamicHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, kCellInset, kCellInset, kCellInset)
    }
    
}

