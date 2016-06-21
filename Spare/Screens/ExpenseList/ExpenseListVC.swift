//
//  ExpenseListVC.swift
//  Spare
//
//  Created by Matt Quiros on 21/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack
import Mold

private enum ViewID: String {
    case Header = "Header"
    case Cell = "Cell"
}

class ExpenseListVC: UIViewController {
    
    let category: Category
    let startDate: NSDate
    let endDate: NSDate
    
    let layoutManager: UICollectionViewFlowLayout
    let collectionView: UICollectionView
    
    var expenses: [Expense]? {
        return glb_protect({[unowned self] in
            let request = NSFetchRequest(entityName: Expense.entityName)
            request.predicate = NSPredicate(format: "category == %@ && dateSpent >= %@ && dateSpent <= %@", self.category, self.startDate, self.endDate)
            if let expenses = try App.state.mainQueueContext.executeFetchRequest(request) as? [Expense]
                where expenses.count > 0 {
                return expenses
            }
            return nil
        })
    }
    
    init(category: Category, startDate: NSDate, endDate: NSDate) {
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        
        self.layoutManager = UICollectionViewFlowLayout()
//        self.layoutManager.estimatedItemSize = CGSizeMake(100, 100)
        self.collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: self.layoutManager)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        self.view = self.collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        self.collectionView.backgroundColor = Color.ExpenseListScreenBackgroundColor
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.registerClass(__ELVCHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ViewID.Header.rawValue)
        self.collectionView.registerNib(__ELVCCell.nib(), forCellWithReuseIdentifier: ViewID.Cell.rawValue)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.shadowImage = UIImage()
            navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            navigationBar.backgroundColor = self.category.color
            navigationBar.tintColor = UIColor.whiteColor()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - UICollectionViewDataSource
extension ExpenseListVC: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let expenses = self.expenses
            else {
                return 0
        }
        return expenses.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewID.Cell.rawValue, forIndexPath: indexPath) as? __ELVCCell
            else {
                fatalError()
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            guard let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: ViewID.Header.rawValue, forIndexPath: indexPath) as? __ELVCHeaderView
                else {
                    fatalError()
            }
            headerView.backgroundColor = self.category.color
            headerView.nameLabel.text = self.category.name
            
            let dateRangeText = glb_displayTextForDateRange(self.startDate, endDate: self.endDate, periodization: .Day)
            let totalText = glb_displayTextForTotal({[unowned self] in
                if let expenses = self.expenses {
                    return glb_totalOfExpenses(expenses)
                }
                return 0
                }())
            headerView.detailLabel.text = "\(dateRangeText): \(totalText)"
            return headerView
            
        default:
            fatalError()
        }
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExpenseListVC: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExpenseListVC: UICollectionViewDelegateFlowLayout {
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        guard let headerView = collectionView.dataSource?.collectionView?(collectionView, viewForSupplementaryElementOfKind: UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as? __ELVCHeaderView
//            else {
//                return CGSizeZero
//        }
//        return CGSizeMake(collectionView.bounds.size.width, headerView.projectedHeight())
//    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let dateRangeText = glb_displayTextForDateRange(self.startDate, endDate: self.endDate, periodization: .Day)
        let totalText = glb_displayTextForTotal({[unowned self] in
            if let expenses = self.expenses {
                return glb_totalOfExpenses(expenses)
            }
            return 0
            }())
        return CGSizeMake(collectionView.bounds.size.width, __ELVCHeaderView.heightForCategoryName(self.category.name!, detailText: "\(dateRangeText): \(totalText)"))
    }
    
}
