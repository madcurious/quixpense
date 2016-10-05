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
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    /// The month that this page displays.
    var month = Date.distantFuture {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    var selectedIndexPath: IndexPath?
    
    var numberOfDays: Int {
        if let count = MonthPageVC.dayCountCache.object(forKey: self.month) as? Int {
            return count
        }
        
        let calendar = Calendar.current
        let count = (calendar as NSCalendar).range(of: .day, in: .month, for: self.month).length
        MonthPageVC.dayCountCache.setObject(count, forKey: self.month)
        return count
    }
    
    var numberOfFillers: Int {
        if let count = MonthPageVC.fillerCountCache.object(forKey: self.month) as? Int {
            return count
        }
        
        let calendar = Calendar.current
        let weekday = (calendar as NSCalendar).component(.weekday, from: month)
        let count = weekday - 1
        MonthPageVC.fillerCountCache.setObject(count, forKey: month)
        return count
    }
    
    init(month: Date, globallySelectedDate: Date) {
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
        
        self.collectionView.isScrollEnabled = false
        self.collectionView.backgroundColor = UIColor.clear
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ViewID.FillerCell.rawValue)
        self.collectionView.register(__DPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.DayCell.rawValue)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleDateSelectionNotification(_:)), name: NSNotificationName.monthPageVCDidSelectDate.string(), object: nil)
    }
    
    func dayForIndexPath(_ indexPath: IndexPath) -> Int {
        let day = (indexPath as NSIndexPath).item - self.numberOfFillers + 1
        return day
    }
    
    func dateForIndexPath(_ indexPath: IndexPath) -> Date {
        let day = self.dayForIndexPath(indexPath)
        let date = (Calendar.current as NSCalendar).date(bySettingUnit: .day, value: day, of: self.month, options: [])!
        return date
    }
    
    func updateSelectedIndexPathFromGloballySelectedDate(_ date: Date) {
        let calendar = Calendar.current
        let selectedDateComponents = (calendar as NSCalendar).components([.month, .day, .year], from: date)
        let monthComponents = (calendar as NSCalendar).components([.month, .day, .year], from: self.month)
        
        // If the globally selected date doesn't fall within this month and year,
        // keep the selected index path nil.
        guard selectedDateComponents.month == monthComponents.month &&
            selectedDateComponents.year == monthComponents.year
            else {
                self.selectedIndexPath = nil
                return
        }
        
        let index = (self.numberOfFillers + selectedDateComponents.day!) - 1 // minus 1 because days start from 1
        let indexPath = IndexPath(item: index, section: 0)
        self.selectedIndexPath = indexPath
    }
    
    func handleDateSelectionNotification(_ notification: Notification) {
        guard let selectedDate = (notification as NSNotification).userInfo?["selectedDate"] as? Date,
            let sender = notification.object as? MonthPageVC
            , notification.name == NSNotificationName.monthPageVCDidSelectDate.string() &&
                sender != self
            else {
                // Avoid reacting to the global notification if the sender is this
                // exact same page.
                return
        }
        
        self.updateSelectedIndexPathFromGloballySelectedDate(selectedDate)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension MonthPageVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberOfFillers + self.numberOfDays
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let index = (indexPath as NSIndexPath).item
        
        if index < self.numberOfFillers {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.FillerCell.rawValue, for: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.DayCell.rawValue, for: indexPath) as! __DPVCDayCell
        cell.dateLabel.text = "\(self.dayForIndexPath(indexPath))"
        
        if let selectedIndexPath = self.selectedIndexPath
            , selectedIndexPath == indexPath {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        
        return cell
    }
    
}

extension MonthPageVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let selectedIndexPath = self.selectedIndexPath {
            // Do nothing if the same date is selected.
            if indexPath == selectedIndexPath {
                return
            }
            
            let oldSelectedIndexPath = selectedIndexPath
            self.selectedIndexPath = indexPath
            self.collectionView.reloadItems(at: [oldSelectedIndexPath, indexPath])
        } else {
            self.selectedIndexPath = indexPath
            self.collectionView.reloadItems(at: [indexPath])
        }
        
        let selectedDate = self.dateForIndexPath(indexPath)
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: NSNotificationName.monthPageVCDidSelectDate.string()), object: self, userInfo: [
                "selectedDate" : selectedDate
            ])
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).item < self.numberOfFillers {
            return false
        }
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        if (indexPath as NSIndexPath).item < self.numberOfFillers ||
            indexPath == self.selectedIndexPath {
            return false
        }
        return true
    }

}

extension MonthPageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Need to set hard value on screen width because of layout problems.
        let width = UIScreen.main.bounds.size.width / 7
        let height = collectionView.bounds.size.height / 6
        return CGSize(width: width, height: height)
    }
    
}
