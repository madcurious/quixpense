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
//    case dayCell = "dayCell"
//    case weekCell = "weekCell"
//    case monthCell = "monthCell"
//    case yearCell = "yearCell"
    case chartCell = "chartCell"
}

fileprivate let kCellClasses = [__HPVCDayCell.self]

class HomePageVC: UIViewController {
    
    enum View {
        case loading, primary, zero
    }
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    let loadingView = OperationVCLoadingView()
    let zeroView = __HPVCZeroView.instantiateFromNib()
    
    var pageData: PageData
    var chartData = [ChartData]()
    
    var categories: [Category] {
        return CategoryProvider.allCategories
    }
    
    init(pageData: PageData) {
        self.pageData = pageData
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        let view = UIView()
        view.addSubviewsAndFill(self.loadingView, self.zeroView, self.collectionView)
        
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
//        self.collectionView.register(__HPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.dayCell.rawValue)
        self.collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ViewID.chartCell.rawValue)
        self.collectionView.register(__HPVCHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.headerView.rawValue)
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
        
        self.showView(.zero)
    }
    
    func showView(_ view: HomePageVC.View) {
        self.zeroView.isHidden = view != .zero
        self.loadingView.isHidden = view != .loading
        self.collectionView.isHidden = view != .primary
    }
    
}

extension HomePageVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewID.headerView.rawValue, for: indexPath) as! __HPVCHeaderView
        headerView.data = self.pageData
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let identifier: String = {
//            switch App.selectedPeriodization {
//            case .day:
//                return ViewID.dayCell.rawValue
//            case .week:
//                return ViewID.weekCell.rawValue
//            case .month:
//                return ViewID.monthCell.rawValue
//            case .year:
//                return ViewID.yearCell.rawValue
//            }
//        }()
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! __HPVCSummaryCell
//        cell.summary = self.summaries[indexPath.item]
//        return cell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.chartCell.rawValue, for: indexPath) as! ChartCell
        cell.chartData = self.chartData[indexPath.item]
        cell.mode = App.selectedPeriodization
        return cell
    }
    
}

extension HomePageVC: UICollectionViewDelegate {}

fileprivate let kInset = CGFloat(10)

extension HomePageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let summary = self.summaries[indexPath.item]
        let chartData = self.chartData[indexPath.item]
        let cellWidth = collectionView.bounds.size.width - kInset * 2
//        let height = kCellClasses[App.selectedPeriodization.rawValue].height(for: chartData, atCellWidth: cellWidth)
        let height = ChartCell.height(for: chartData, atCellWidth: cellWidth)
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
