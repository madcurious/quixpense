//
//  DatePickerVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case PageCell = "PageCell"
}

class DatePickerVC: UIViewController {
    
    let customView = __DPVCView.instantiateFromNib() as __DPVCView
    
    var months = [NSDate]()
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
        collectionView.registerNib(__DPVCPageCell.nib(), forCellWithReuseIdentifier: ViewID.PageCell.rawValue)
        let layoutManager = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutManager.scrollDirection = .Horizontal
        
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: NSDate())
        components.day = 1
        let currentMonth = calendar.dateFromComponents(components)!
        self.months = [currentMonth]
        
        let months = self.generateMonthsBeforeDate(self.months[0])
        self.months.insertContentsOf(months, at: 0)
        self.customView.collectionView.reloadData()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let lastPageX = self.customView.collectionView.contentSize.width - UIScreen.mainScreen().bounds.width
        self.customView.collectionView.setContentOffset(CGPointMake(lastPageX, 0), animated: false)
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.months.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.PageCell.rawValue, forIndexPath: indexPath) as! __DPVCPageCell
        cell.month = self.months[indexPath.item]
        
        return cell
    }
    
}

extension DatePickerVC: UICollectionViewDelegate {
    
}

extension DatePickerVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSizeMake(UIScreen.mainScreen().bounds.width, self.customView.collectionViewHeight.constant
        )
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}