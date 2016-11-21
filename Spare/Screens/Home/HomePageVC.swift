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
    
    static let cellIdentifiers = [
        ViewID.dayCell.rawValue
    ]
}

fileprivate let kCellClasses = [__HPVCDayCell.self]

class HomePageVC: MDOperationViewController {
    
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var pageData: PageData
    var chartData = [ChartData]()
    
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
        self.collectionView.register(__HPVCDayCell.nib(), forCellWithReuseIdentifier: ViewID.dayCell.rawValue)
        self.collectionView.register(__HPVCHeaderView.nib(), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.headerView.rawValue)
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .vertical
    }
    
    override func makeOperation() -> MDOperation? {
//        return MDBlockOperation {
//            // Fetch all categories if still nil.
//            guard App.allCategories == nil
//                else {
//                    return nil
//            }
//            
//            let context = App.coreDataStack.viewContext
//            let request = FetchRequestBuilder<Category>.makeFetchRequest()
//            let categories = try context.fetch(request).sorted(by: { $0.expenses?.count ?? 0 > $1.expenses?.count ?? 0 })
//            return categories
//        }
//        .onSuccess({[unowned self] (result) in
//            if let categories = result as? [Category] {
//                App.allCategories = categories
//            }
//            
//            self.operationQueue.addOperation(
//                MakeChartDataOperation(pageData: self.pageData, periodization: App.selectedPeriodization)
//                .onSuccess({[unowned self] (result) in
//                    self.chartData = result as! [ChartData]
//                    self.collectionView.reloadData()
//                    
//                    self.updateView(forState: .displaying)
//                })
//            )
//        })
        
        return MakeChartDataOperation(pageData: self.pageData, periodization: App.selectedPeriodization)
            .onSuccess({[unowned self] (result) in
                self.chartData = result as! [ChartData]
                self.collectionView.reloadData()
                
                self.updateView(forState: .displaying)
                })
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
        headerView.data = self.pageData
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = ViewID.cellIdentifiers[App.selectedPeriodization.rawValue]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! __HPVCChartCell
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
        let height = kCellClasses[indexPath.item].height(for: chartData, atCellWidth: cellWidth)
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
