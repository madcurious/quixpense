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
    
    var selectedDate: NSDate? {
        didSet {
        }
    }
    
    enum PageDirection {
        case Previous, Next
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup collection view.
        let collectionView = self.customView.collectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerNib(__DPVCPageCell.nib(), forCellWithReuseIdentifier: ViewID.PageCell.rawValue)
        let layoutManager = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layoutManager.scrollDirection = .Horizontal
        
        // Add the current month to the data source.
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: NSDate())
        components.day = 1
        let currentMonth = calendar.dateFromComponents(components)!
        self.months.append(currentMonth)
        self.customView.collectionView.reloadData()
        
        self.selectedDate = currentMonth
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOnDimView))
        tapGesture.cancelsTouchesInView = false
        self.customView.dimView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        // Initially display the selected date.
//        guard let selectedDate = self.selectedDate,
//        let index = self.months.indexOf(selectedDate)
//            else {
//                return
//        }
//        self.view.setNeedsLayout()
//        self.view.layoutIfNeeded()
//        self.customView.collectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: .CenteredHorizontally, animated: false)
        
        
        
        let previousMonths = self.generateMonthsFromDate(self.selectedDate!, forPageDirection: .Previous)
        let nextMonths = self.generateMonthsFromDate(self.selectedDate!, forPageDirection: .Next)
        self.customView.collectionView.performBatchUpdates({[unowned self] in
            self.months.insertContentsOf(previousMonths, at: 0)
            var previousIndexPaths = [NSIndexPath]()
            for i in 0 ..< previousMonths.count {
                previousIndexPaths.append(NSIndexPath(forItem: i, inSection: 0))
            }
            self.customView.collectionView.insertItemsAtIndexPaths(previousIndexPaths)
            
            let insertionPoint = self.months.count
            self.months.appendContentsOf(nextMonths)
            var nextIndexPaths = [NSIndexPath]()
            for i in 0 ..< nextMonths.count {
                nextIndexPaths.append(NSIndexPath(forItem: insertionPoint + i, inSection: 0))
            }
            self.customView.collectionView.insertItemsAtIndexPaths(nextIndexPaths)
            }, completion: nil)
    }
    
    func generateMonthsFromDate(date: NSDate, forPageDirection pageDirection: PageDirection) -> [NSDate] {
        // Use the first day of the month as the base date.
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Month, .Day, .Year], fromDate: date)
        components.day = 1
        let baseMonth = calendar.dateFromComponents(components)!
        
        var months = [NSDate]()
        for i in 1 ... 6 {
            let increment = pageDirection == .Previous ? -(i) : i
            let newMonth = calendar.dateByAddingUnit(.Month, value: increment, toDate: baseMonth, options: [])!
            let insertionIndex = pageDirection == .Previous ? 0 : months.count
            months.insert(newMonth, atIndex: insertionIndex)
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