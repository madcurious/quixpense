//
//  DatePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case Header = "Header"
    case Cell = "Cell"
}

class DatePickerVC: UIViewController {
    
    let customView = __DPVCView.instantiateFromNib() as __DPVCView
    
    var months = [NSDate()]
    let dayCountCache = NSCache()
    let fillerCountCache = NSCache()
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let collectionView = self.customView.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(__DPVCCell.nib(), forCellWithReuseIdentifier: ViewID.Cell.rawValue)
        collectionView.registerNib(__DPVCHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Header.rawValue)
        let layoutManager = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutManager.scrollDirection = .Horizontal
        layoutManager.sectionHeadersPinToVisibleBounds = true
        
        let months = self.generateMonthsBeforeDate(self.months[0])
        self.months.insertContentsOf(months, at: 0)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
    }
    
    func generateMonthsBeforeDate(date: NSDate) -> [NSDate] {
        // Use the first day of the month as the base date.
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: date)
        components.day = 1
        let baseMonth = calendar.dateFromComponents(components)!
        
        var months = [NSDate]()
        for i in 1 ... 12 {
            let newMonth = calendar.dateByAddingUnit(.Month, value: -(i), toDate: baseMonth, options: [])!
            months.insert(newMonth, atIndex: 0)
        }
        return months
    }
    
    func handleTapOnDimView() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension DatePickerVC: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return self.months.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of days in that month.
        // Check the cache first.
        let month = self.months[section]
        if let dayCount = self.dayCountCache.objectForKey(month) as? Int {
            return dayCount
        }
        
        // If the count isn't in the cache, count it, then cache the number.
        let calendar = NSCalendar.currentCalendar()
        let dayCount = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: month).length
        self.dayCountCache.setObject(dayCount, forKey: month)
        return dayCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.Cell
            .rawValue, forIndexPath: indexPath) as! __DPVCCell
        cell.dateLabel.text = "\(indexPath.item)"
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Header.rawValue, forIndexPath: indexPath)
    }
    
}

extension DatePickerVC: UICollectionViewDelegate {
    
}

extension DatePickerVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: section)
        let headerWidth = collectionView.bounds.size.width - insets.left - insets.right
        let size = CGSizeMake(headerWidth, 30)
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let headerSize = self.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: indexPath.section)
        let remainingHeight = collectionView.bounds.size.height - headerSize.height
        let tileHeight = remainingHeight / 5
        
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAtIndex: indexPath.section)
        let tileWidth = (collectionView.bounds.size.width - insets.left - insets.right) / 7
        
        return CGSizeMake(tileWidth, tileHeight)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 10, 0, 10)
    }
    
}