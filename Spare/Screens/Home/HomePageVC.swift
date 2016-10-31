//
//  HomePageVC.swift
//  Spare
//
//  Created by Matt Quiros on 24/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

fileprivate enum ViewID: String {
    case headerView = "headerView"
    case dayCell = "dayCell"
    case weekCell = "weekCell"
    case monthCell = "monthCell"
    case yearCell = "yearCell"
}

fileprivate let kCellClasses = [__HPVCDayCell.self]

class HomePageVC: MDOperationViewController {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let customLoadingView = OperationVCLoadingView()
    let zeroView = __HPVCZeroView.instantiateFromNib()
    
    var data = (NSDecimalNumber(value: 0), [Summary]())
    
    var total: NSDecimalNumber {
        return self.data.0
    }
    
    var summaries : [Summary] {
        return self.data.1
    }
    
    override var loadingView: UIView {
        return self.customLoadingView
    }
    
    override var noResultsView: UIView {
        return self.zeroView
    }
    
    override var primaryView: UIView {
        return self.collectionView
    }
    
    var dateRange: DateRange
    
    init(dateRange: DateRange) {
        self.dateRange = dateRange
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(__HPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.dayCell.rawValue)
        self.collectionView.register(__HPVCHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.headerView.rawValue)
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
        
        self.showView(.noResults)
    }
    
    override func makeOperation() -> MDOperation? {
        return MakeSummariesOperation(dateRange: self.dateRange)
            .onSuccess({[unowned self] result in
                self.data = result as! (NSDecimalNumber, [Summary])
                self.showView(.primary)
                self.collectionView.reloadData()
            })
    }
    
}

extension HomePageVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.summaries.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewID.headerView.rawValue, for: indexPath) as! __HPVCHeaderView
        headerView.data = (self.dateRange, self.total)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier: String = {
            switch App.selectedPeriodization {
            case .day:
                return ViewID.dayCell.rawValue
            case .week:
                return ViewID.weekCell.rawValue
            case .month:
                return ViewID.monthCell.rawValue
            case .year:
                return ViewID.yearCell.rawValue
            }
        }()
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! __HPVCSummaryCell
        cell.summary = self.summaries[indexPath.item]
        return cell
    }
    
}

extension HomePageVC: UICollectionViewDelegate {}

fileprivate let kInset = CGFloat(10)

extension HomePageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let summary = self.summaries[indexPath.item]
        let cellWidth = collectionView.bounds.size.width - kInset * 2
        let height = kCellClasses[App.selectedPeriodization.rawValue].height(for: summary, atCellWidth: cellWidth)
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
