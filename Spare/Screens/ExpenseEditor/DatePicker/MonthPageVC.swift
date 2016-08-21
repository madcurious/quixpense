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
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    var month: NSDate? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    static let dayCountCache = NSCache()
    static let fillerCountCache = NSCache()
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.scrollEnabled = false
        self.collectionView.backgroundColor = UIColor.randomColor()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: ViewID.FillerCell.rawValue)
        self.collectionView.registerNib(__DPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.DayCell.rawValue)
    }
    
}

extension MonthPageVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let month = self.month
            else {
                return 0
        }
        
        // Return the number of days in that month.
        // Check the cache first.
        if let fillerCount = MonthPageVC.fillerCountCache.objectForKey(month) as? Int,
            let dayCount = MonthPageVC.dayCountCache.objectForKey(month) as? Int {
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .ShortStyle
            print("\(formatter.stringFromDate(month)) - filler: \(fillerCount), dayCount: \(dayCount)")
            return fillerCount + dayCount
        }
        
        // If the count isn't in the cache, count it, then cache the number.
        let calendar = NSCalendar.currentCalendar()
        let dayCount = calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: month).length
        MonthPageVC.dayCountCache.setObject(dayCount, forKey: month)
        
        let weekday = calendar.component(.Weekday, fromDate: month)
        let fillerCount = weekday - 1
        MonthPageVC.fillerCountCache.setObject(fillerCount, forKey: month)
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        print("\(formatter.stringFromDate(month)) - filler: \(fillerCount), dayCount: \(dayCount)")
        
        return fillerCount + dayCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.item
        let fillerCount = MonthPageVC.fillerCountCache.objectForKey(self.month!) as! Int
        
        if index < fillerCount {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.FillerCell.rawValue, forIndexPath: indexPath)
            return cell
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.DayCell.rawValue, forIndexPath: indexPath) as! __DPVCDayCell
        cell.dateLabel.text = "\(index - fillerCount + 1)"
        return cell
    }
    
}

extension MonthPageVC: UICollectionViewDelegate {}

extension MonthPageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width = collectionView.bounds.size.width / 7
        let height = collectionView.bounds.size.height / 6
        return CGSizeMake(width, height)
    }
    
}
