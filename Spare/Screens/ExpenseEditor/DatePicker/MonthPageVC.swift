//
//  MonthPageVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/08/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit

private enum ViewID: String {
    case FillerCell = "FillerCell"
    case DayCell = "DayCell"
}

class MonthPageVC: UIViewController {
    
    static let dayCountCache = NSCache()
    static let fillerCountCache = NSCache()
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    /// The month that this page displays.
    var month = NSDate.distantFuture() {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var selectedIndexPath: NSIndexPath?
    
    var numberOfDays: Int {
        if let count = MonthPageVC.dayCountCache.objectForKey(self.month) as? Int {
            return count
        }
        
        let calendar = NSCalendar.currentCalendar()
        let count = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: self.month).length
        MonthPageVC.dayCountCache.setObject(count, forKey: self.month)
        return count
    }
    
    var numberOfFillers: Int {
        if let count = MonthPageVC.fillerCountCache.objectForKey(self.month) as? Int {
            return count
        }
        
        let calendar = NSCalendar.currentCalendar()
        let weekday = calendar.component(.Weekday, fromDate: month)
        let count = weekday - 1
        MonthPageVC.fillerCountCache.setObject(count, forKey: month)
        return count
    }
    
    init(month: NSDate, globallySelectedDate: NSDate) {
        super.init(nibName: nil, bundle: nil)
        self.month = month
        self.updateSelectedIndexPathFromGloballySelectedDate(globallySelectedDate)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.scrollEnabled = false
        self.collectionView.backgroundColor = UIColor.clearColor()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ViewID.FillerCell.rawValue)
        self.collectionView.registerNib(__DPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.DayCell.rawValue)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleDateSelectionNotification(_:)), name: NSNotificationName.MonthPageVCDidSelectDate.string(), object: nil)
    }
    
    func dayForIndexPath(indexPath: NSIndexPath) -> Int {
        let day = indexPath.item - self.numberOfFillers + 1
        return day
    }
    
    func dateForIndexPath(indexPath: NSIndexPath) -> NSDate {
        let day = self.dayForIndexPath(indexPath)
        let date = NSCalendar.currentCalendar().dateBySettingUnit(.Day, value: day, ofDate: self.month, options: [])!
        return date
    }
    
    func updateSelectedIndexPathFromGloballySelectedDate(date: NSDate) {
        let calendar = NSCalendar.currentCalendar()
        let selectedDateComponents = calendar.components([.Month, .Day, .Year], fromDate: date)
        let monthComponents = calendar.components([.Month, .Day, .Year], fromDate: self.month)
        
        // If the globally selected date doesn't fall within this month and year,
        // keep the selected index path nil.
        guard selectedDateComponents.month == monthComponents.month &&
            selectedDateComponents.year == monthComponents.year
            else {
                self.selectedIndexPath = nil
                return
        }
        
        let index = (self.numberOfFillers + selectedDateComponents.day) - 1 // minus 1 because days start from 1
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        self.selectedIndexPath = indexPath
    }
    
    func handleDateSelectionNotification(notification: NSNotification) {
        guard let selectedDate = notification.userInfo?["selectedDate"] as? NSDate,
            let sender = notification.object as? MonthPageVC
            where notification.name == NSNotificationName.MonthPageVCDidSelectDate.string() &&
                sender != self
            else {
                // Avoid reacting to the global notification if the sender is this
                // exact same page.
                return
        }
        
        self.updateSelectedIndexPathFromGloballySelectedDate(selectedDate)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}

extension MonthPageVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfFillers + self.numberOfDays
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        
        if index < self.numberOfFillers {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.FillerCell.rawValue, forIndexPath: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.DayCell.rawValue, forIndexPath: indexPath) as! __DPVCDayCell
        cell.dateLabel.text = "\(self.dayForIndexPath(indexPath))"
        
        if let selectedIndexPath = self.selectedIndexPath
            where selectedIndexPath == indexPath {
            cell.selected = true
        } else {
            cell.selected = false
        }
        
        return cell
    }
    
}

extension MonthPageVC: UICollectionViewDelegate {

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            // Do nothing if the same date is selected.
            if indexPath == selectedIndexPath {
                return
            }
            
            let oldSelectedIndexPath = selectedIndexPath
            self.selectedIndexPath = indexPath
            self.collectionView.reloadItemsAtIndexPaths([oldSelectedIndexPath, indexPath])
        } else {
            self.selectedIndexPath = indexPath
            self.collectionView.reloadItemsAtIndexPaths([indexPath])
        }
        
        let selectedDate = self.dateForIndexPath(indexPath)
        NSNotificationCenter.defaultCenter().postNotificationName(
            NSNotificationName.MonthPageVCDidSelectDate.string(), object: self, userInfo: [
                "selectedDate" : selectedDate
            ])
    }
    
    func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.item < self.numberOfFillers {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.item < self.numberOfFillers {
            return false
        }
        return true
    }

}

extension MonthPageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Need to set hard value on screen width because of layout problems.
        let width = UIScreen.mainScreen().bounds.size.width / 7
        let height = collectionView.bounds.size.height / 6
        return CGSizeMake(width, height)
    }
    
}
