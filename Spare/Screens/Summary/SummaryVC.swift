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
    case Graph = "Graph"
    case Cell = "Cell"
    case Footer = "Footer"
}

class SummaryVC: UIViewController {
    
    var summary: Summary {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
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
        
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = Color.White
        self.collectionView.showsVerticalScrollIndicator = false
        
        self.collectionView.registerNib(__SVCGraphView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Graph.rawValue)
        self.collectionView.registerNib(__SVCCategoryCellStub.nib(), forCellWithReuseIdentifier: ViewID.Cell.rawValue)
        self.collectionView.registerNib(CollectionViewLabel.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: ViewID.Footer.rawValue)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
    }
    
}

// MARK: - UICollectionViewDataSource
extension SummaryVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let categories = glb_allCategories()
            else {
                return 0
        }
        return categories.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.Cell.rawValue, forIndexPath: indexPath) as? __SVCCategoryCell
            else {
                fatalError()
        }
        
        cell.info = self.summary.info?[indexPath.item]
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let graphView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.Graph.rawValue, forIndexPath: indexPath) as? __SVCGraphView
                else {
                    fatalError()
            }
            
            graphView.totalLabel.text = glb_displayTextForTotal(self.summary.total)
            graphView.summary = self.summary
            
            return graphView
            
        case UICollectionElementKindSectionFooter:
            guard let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.Footer.rawValue, forIndexPath: indexPath) as? CollectionViewLabel
                else {
                    fatalError()
            }
            
            let textAttributes = [
                NSForegroundColorAttributeName : Color.SummaryFooterViewTextColor,
                NSFontAttributeName : Font.SummaryFooterViewText
            ]
            let text = NSMutableAttributedString(string: "Press and hold ", attributes: textAttributes)
            text.appendAttributedString(NSAttributedString(string: Icon.MainTabBarAdd.rawValue, attributes: [
                NSForegroundColorAttributeName : Color.SummaryFooterViewTextColor,
                NSFontAttributeName : Font.icon(14)
                ]))
            text.appendAttributedString(NSAttributedString(string: " to add a\nnew category.", attributes: textAttributes))
            
            footerView.label.attributedText = text
            footerView.label.numberOfLines = 2
            footerView.label.lineBreakMode = .ByWordWrapping
            
            return footerView
            
        default:
            fatalError()
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension SummaryVC: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard let category = self.summary.info?[indexPath.item].0
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

// MARK: - UICollectionViewDelegateFlowLayout
extension SummaryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width * 0.9)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 54)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, 60)
    }
    
}
