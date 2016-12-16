//
//  HomePageVC.swift
//  Spare
//
//  Created by Matt Quiros on 24/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

fileprivate enum ViewID: String {
    case headerView = "headerView"
    case dayCell = "dayCell"
    case weekCell = "weekCell"
    case monthCell = "monthCell"
    
    static let cellIdentifiers = [
        ViewID.dayCell.rawValue,
        ViewID.weekCell.rawValue,
        ViewID.monthCell.rawValue
    ]
}

fileprivate let kCellClasses: [_HPVCChartCell.Type] = [_HPVCDayCell.self, _HPVCWeekCell.self, _HPVCMonthCell.self]

class HomePageVC: MDFullOperationViewController {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var dateRange: DateRange
    var dateRangeTotal = NSDecimalNumber(value: 0)
    var chartData = [ChartData]()
    
    init(dateRange: DateRange) {
        self.dateRange = dateRange
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateView(forState: .loading)
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(__HPVCHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.headerView.rawValue)
        self.collectionView.register(_HPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.dayCell.rawValue)
        self.collectionView.register(_HPVCWeekCell.nib(), forCellWithReuseIdentifier: ViewID.weekCell.rawValue)
        self.collectionView.register(_HPVCMonthCell.nib(), forCellWithReuseIdentifier: ViewID.monthCell.rawValue)
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
        
        let system = NotificationCenter.default
        
        // The page should re-run the operation whenever an MOC saves.
        system.addObserver(self, selector: #selector(handleContextDidSaveNotification(notification:)), name: Notification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    
    override func makeOperation() -> MDOperation? {
        return MakePageDataOperation(dateRange: self.dateRange, periodization: App.selectedPeriodization)
            .onSuccess({[unowned self] (result) in
                let (dateRangeTotal, chartData) = result as! (NSDecimalNumber, [ChartData])
                self.dateRangeTotal = dateRangeTotal
                self.chartData = chartData
                self.collectionView.reloadData()
                self.updateView(forState: .displaying)
                })
    }
    
    func handleContextDidSaveNotification(notification: Notification) {
        guard notification.name == Notification.Name.NSManagedObjectContextDidSave
            else {
                return
        }
        
        // I initially put a checker to re-run only when a Category or Expense is updated,
        // but inserting/updating/deleting an Expense also includes its Category in the userInfo,
        // so the re-run will be triggered almost always whenever there's a save.
        self.runOperation()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension HomePageVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.chartData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewID.headerView.rawValue, for: indexPath) as! __HPVCHeaderView
        headerView.data = (self.dateRange, self.dateRangeTotal)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = ViewID.cellIdentifiers[App.selectedPeriodization.rawValue]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! _HPVCChartCell
        cell.chartData = self.chartData[indexPath.item]
        return cell
    }
    
}

extension HomePageVC: UICollectionViewDelegate {}

fileprivate let kInset = CGFloat(10)

extension HomePageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chartData = self.chartData[indexPath.item]
        let cellWidth = collectionView.bounds.size.width - kInset * 2
        let height = kCellClasses[App.selectedPeriodization.rawValue].height(for: chartData, atCellWidth: cellWidth)
        return CGSize(width: cellWidth, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.size.width - kInset * 2
        return CGSize(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kInset
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, kInset, kInset, kInset)
    }
    
}
