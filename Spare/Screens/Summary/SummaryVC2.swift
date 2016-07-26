//
//  SummaryVC2.swift
//  Spare
//
//  Created by Matt Quiros on 20/07/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case Graph = "Graph"
    case CategoryCell = "CategoryCell"
    case SectionHeader = "SectionHeader"
}

class SummaryVC2: UIViewController {
    
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
        self.collectionView.registerNib(__SVCCategoryCellBadge.nib(), forCellWithReuseIdentifier: ViewID.CategoryCell.rawValue)
        self.collectionView.registerNib(__SVCSectionHeaderWithRightButton.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.SectionHeader.rawValue)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
}

extension SummaryVC2: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            guard let categories = glb_allCategories()
                else {
                    return 0
            }
            return categories.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 1:
            guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.CategoryCell.rawValue, forIndexPath: indexPath) as? __SVCCategoryCellBadge
                else {
                    fatalError()
            }
            cell.info = self.summary.info?[indexPath.item]
            return cell
            
        default:
            fatalError()
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            if indexPath.section == 0 {
                guard let graphView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.Graph.rawValue, forIndexPath: indexPath) as? __SVCGraphView
                    else {
                        fatalError()
                }
                graphView.totalLabel.text = glb_displayTextForTotal(self.summary.total)
                graphView.summary = self.summary
                return graphView
            }
            
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.SectionHeader.rawValue, forIndexPath: indexPath) as? __SVCSectionHeaderWithRightButton
                else {
                    fatalError()
            }
            sectionHeader.sectionLabel.text = "TOP CATEGORIES"
            sectionHeader.rightButtonText = "VIEW ALL"
            return sectionHeader
            
        default:
            fatalError()
        }
    }
    
}

extension SummaryVC2: UICollectionViewDelegate {
    
}

extension SummaryVC2: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            return CGSizeMake(collectionView.bounds.size.width, collectionView.bounds.size.width * 0.9)
            
        case 1:
            return CGSizeMake(collectionView.bounds.size.width, 20)
            
        default:
            return CGSizeZero
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionView.bounds.size.width, 44)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    
}
