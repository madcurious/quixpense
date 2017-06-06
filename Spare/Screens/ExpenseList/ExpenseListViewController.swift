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
    
    let customView = ExpenseListView.instantiateFromNib()
    let totalCache = NSCache<NSNumber, NSDecimalNumber>()
    
    let fetchedResultsController: NSFetchedResultsController<CategoryGroup> = {
        let fetchRequest = FetchRequest<CategoryGroup>.make()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(CategoryGroup.sectionDate), ascending: false)
        ]
        return NSFetchedResultsController(fetchRequest: fetchRequest,
                                          managedObjectContext: Global.coreDataStack.viewContext,
                                          sectionNameKeyPath: #keyPath(CategoryGroup.sectionDate),
                                          cacheName: "CacheName")
    }()
    
    let filterButton: FilterButton = {
        let filterButton = FilterButton.instantiateFromNib()
        filterButton.sizeToFit()
        return filterButton
    }()
    
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
        
        self.filterButton.addTarget(self, action: #selector(handleTapOnFilterButton), for: .touchUpInside)
        
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

}

// MARK: - Target actions
extension ExpenseListViewController {
    
    func handleTapOnFilterButton() {
        let filterPopup = FilterPopupViewController()
        let modal = BaseNavBarVC(rootViewController: filterPopup)
        modal.modalPresentationStyle = .popover
        
        guard let popoverController = modal.popoverPresentationController
            else {
                return
        }
        popoverController.delegate = self
        
        popoverController.sourceView = self.filterButton
        popoverController.sourceRect = self.filterButton.frame
        popoverController.permittedArrowDirections = [.up]
        let filterPopupViewSize = filterPopup.customView.sizeThatFits(CGSize(width: 300, height: CGFloat.greatestFiniteMagnitude))
        modal.preferredContentSize = CGSize(width: 300,
                                            height: filterPopupViewSize.height)
        
        self.present(modal, animated: true, completion: nil)
    }
    
}

extension ExpenseListViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewID.groupCell.rawValue, for: indexPath) as! ExpenseListGroupCell
        cell.categoryGroup = self.fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader,
                                                                         withReuseIdentifier: ViewID.sectionHeader.rawValue,
                                                                         for: indexPath) as! ExpenseListSectionHeader
        headerView.dateString = self.fetchedResultsController.sections?[indexPath.section].name
        headerView.sectionTotal = NSDecimalNumber(value: 9999.99)
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
    
}
