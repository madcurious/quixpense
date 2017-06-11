//
//  ExpenseListViewController.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import CoreData

fileprivate enum ViewID: String {
    case sectionHeader = "SectionHeader"
    case groupCell = "GroupCell"
    case expenseCell = "ExpenseCell"
}

class ExpenseListViewController: MDLoadableViewController {
    
    let filterButton = FilterButton.instantiateFromNib()
    let customView = ExpenseListView.instantiateFromNib()
    
    let fetchedResultsController = ExpenseListViewController.makeFetchedResultsController(for: Global.filter)
    let sectionTotals = NSCache<NSString, NSDecimalNumber>()
    var expandedIndexPaths = Set<IndexPath>()
    
    class func makeFetchedResultsController(for filter: Filter) -> NSFetchedResultsController<DayCategoryGroup> {
        switch filter.grouping {
        case .category:
            let fetchRequest = FetchRequest<DayCategoryGroup>.make()
            var sortDescriptors = [NSSortDescriptor(key: #keyPath(DayCategoryGroup.total), ascending: false)]
            
            switch filter.periodization {
            case .day:
                sortDescriptors.insert(NSSortDescriptor(key: #keyPath(DayCategoryGroup.date), ascending: false), at: 0)
                
            case .week, .month:
                break
            }
            
            fetchRequest.sortDescriptors = sortDescriptors
            fetchRequest.fetchBatchSize = 100
            
            return NSFetchedResultsController(fetchRequest: fetchRequest,
                                              managedObjectContext: Global.coreDataStack.viewContext,
                                              sectionNameKeyPath: #keyPath(DayCategoryGroup.date),
                                              cacheName: "CacheName")
            
        case .tag:
            fatalError("Unimplemented")
        }
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.tabBarItem.image = UIImage.templateNamed("tabIconExpenseList")
        self.navigationItem.titleView = self.filterButton
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.customView.collectionView.register(ExpenseListSectionHeader.nib(),
                                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                                withReuseIdentifier: ViewID.sectionHeader.rawValue)
        self.customView.collectionView.register(ExpenseListGroupCell.nib(),
                                                forCellWithReuseIdentifier: ViewID.groupCell.rawValue)
        self.customView.collectionView.dataSource = self
        self.customView.collectionView.delegate = self
        
        self.performFetch()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.customView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func performFetch() {
        self.showView(for: .loading)
        do {
            try self.fetchedResultsController.performFetch()
            if let count = self.fetchedResultsController.fetchedObjects?.count,
                count == 0 {
                self.showView(for: .empty)
            } else {
                self.customView.collectionView.reloadData()
                self.showView(for: .data)
            }
        } catch {
            self.showView(for: .error(error))
        }
    }
    
    override func showView(for state: MDLoadableViewController.State) {
        super.showView(for: state)
        
        self.customView.activityIndicatorView.isHidden = state != .initial || state != .loading
        self.customView.noExpensesLabel.isHidden = state != .empty
        self.customView.collectionView.isHidden = state != .data
    }
    
    func computeTotal(forSection section: Int) -> NSDecimalNumber {
        var total = NSDecimalNumber(value: 0)
        guard let groups = self.fetchedResultsController.sections?[section].objects as? [DayCategoryGroup]
            else {
                return total
        }
        
        groups.forEach { group in
            total = total.adding(group.total ?? 0)
        }
        return total
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension ExpenseListViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.performFetch()
    }
    
}

// MARK: - UICollectionViewDataSource
extension ExpenseListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let sections = self.fetchedResultsController.sections
            else {
                return 0
        }
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchedResultsController.sections?[section]
            else {
                return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.groupCell.rawValue,
                                                      for: indexPath) as! ExpenseListGroupCell
        cell.categoryGroup = self.fetchedResultsController.object(at: indexPath)
        
        if self.expandedIndexPaths.contains(indexPath) {
            cell.isExpanded = true
        } else {
            cell.isExpanded = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: ViewID.sectionHeader.rawValue,
                                                                         for: indexPath) as! ExpenseListSectionHeader
        
        if let sectionName = self.fetchedResultsController.sections?[indexPath.section].name {
            headerView.dateString = sectionName
            headerView.sectionTotal = {
                if let total = self.sectionTotals.object(forKey: sectionName as NSString) {
                    return total
                } else {
                    let total = self.computeTotal(forSection: indexPath.section)
                    self.sectionTotals.setObject(total, forKey: sectionName as NSString)
                    return total
                }
            }()
        }
        
        return headerView
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ExpenseListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = {
            if self.traitCollection.horizontalSizeClass == .compact {
                return collectionView.bounds.size.width
            }
            return collectionView.bounds.size.width * 0.7
        }()
        
        if self.expandedIndexPaths.contains(indexPath) {
            return CGSize(width: width, height: ExpenseListGroupCell.expandedHeight(for: self.fetchedResultsController.object(at: indexPath)))
        }
        return CGSize(width: width, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width: CGFloat = {
            if self.traitCollection.horizontalSizeClass == .compact {
                return collectionView.bounds.size.width
            }
            return collectionView.bounds.size.width * 0.7
        }()
        return CGSize(width: width, height: 22)
    }
    
}

// MARK: - UICollectionViewDelegate
extension ExpenseListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Remove highlight.
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let groupCell = collectionView.cellForItem(at: indexPath) as? ExpenseListGroupCell
            else {
                return
        }
        
        if self.expandedIndexPaths.contains(indexPath) {
            self.expandedIndexPaths.remove(indexPath)
            groupCell.isExpanded = false
        } else  {
            self.expandedIndexPaths.insert(indexPath)
            groupCell.isExpanded = true
        }
        
        collectionView.performBatchUpdates(nil, completion: nil)
    }
    
}
