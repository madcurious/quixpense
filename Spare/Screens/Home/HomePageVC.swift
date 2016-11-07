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
    case chartCell = "chartCell"
}

fileprivate let kCellClasses = [__HPVCDayCell.self]

class HomePageVC: UIViewController {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(ChartCell.self, forCellWithReuseIdentifier: ViewID.chartCell.rawValue)
        self.collectionView.register(__HPVCHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.headerView.rawValue)
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
        
        for category in self.categories {
            let chartData = ChartData(category: category, pageData: self.pageData)
            self.chartData.append(chartData)
        }
        self.collectionView.reloadData()
    }
    
}

extension HomePageVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.categories.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ViewID.headerView.rawValue, for: indexPath) as! __HPVCHeaderView
        headerView.data = self.pageData
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.chartCell.rawValue, for: indexPath) as! ChartCell
        cell.data = (self.chartData[indexPath.item], App.selectedPeriodization)
        return cell
    }
    
}

extension HomePageVC: UICollectionViewDelegate {}

fileprivate let kInset = CGFloat(10)

extension HomePageVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let chartData = self.chartData[indexPath.item]
        let cellWidth = collectionView.bounds.size.width - kInset * 2
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
