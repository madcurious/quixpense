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
    case cell = "Cell"
    case header = "Header"
}

class ExpenseListViewController: MDLoadableViewController {
    
    let customView = ExpenseListView.instantiateFromNib()
    let totalCache = NSCache<NSNumber, NSDecimalNumber>()
    
    let fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
//        let fetchRequest = FetchRequest<Expense>.make()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Expense")
        fetchRequest.resultType = .dictionaryResultType
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Expense.sectionDate), ascending: false)
//            NSSortDescriptor(key: #keyPath(Expense.dateCreated), ascending: false)
        ]
        
//        let sumExpressionDescription = NSExpressionDescription()
//        sumExpressionDescription.name = "sum"
//        sumExpressionDescription.expressionResultType = .decimalAttributeType
//        sumExpressionDescription.expression = NSExpression(forFunction: "sum:", arguments: [#keyPath(Expense.amount)])
        
        fetchRequest.propertiesToFetch = [
            #keyPath(Expense.category)
//            sumExpressionDescription
        ]
        fetchRequest.propertiesToGroupBy = [
            #keyPath(Expense.category)
        ]
        fetchRequest.fetchLimit = 50
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: Global.coreDataStack.viewContext,
                                                                  sectionNameKeyPath: #keyPath(Expense.sectionDate),
                                                                  cacheName: nil)
        return fetchedResultsController
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
        
//        self.fetchedResultsController.delegate = self
        
        do {
            try self.fetchedResultsController.performFetch()
//            if let count = self.fetchedResultsController.fetchedObjects?.count {
//                if count == 0 {
//                    self.updateView(forState: .empty)
//                } else {
//                    self.updateView(forState: .showing)
//                }
//            }
            
            if let fetchedObjects = self.fetchedResultsController.fetchedObjects {
                print(fetchedObjects)
            }
        } catch {
            
        }
    }
    
    override func updateView(forState state: MDLoadableViewController.State) {
        super.updateView(forState: state)
        
        self.customView.activityIndicatorView.isHidden = state != .initial || state != .loading
        self.customView.noExpensesLabel.isHidden = state != .empty
        self.customView.collectionView.isHidden = state != .showing
    }
    
    @discardableResult
    func computeAndCacheTotal(for section: Int) -> NSDecimalNumber {
        if let expenses = self.fetchedResultsController.sections?[section].objects as? [Expense],
            expenses.count > 0 {
            let total = expenses.total()
            self.totalCache.setObject(total, forKey: NSNumber(value: section))
            return total
        } else {
            self.totalCache.removeObject(forKey: NSNumber(value: section))
            return NSDecimalNumber(value: 0)
        }
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
        switch controller.fetchedObjects?.count ?? 0 {
        case 0:
            self.updateView(forState: .empty)
            
        default:
            self.updateView(forState: .showing)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if let oldSection = indexPath?.section {
            self.computeAndCacheTotal(for: oldSection)
        }
        
        if let newSection = newIndexPath?.section {
            self.computeAndCacheTotal(for: newSection)
        }
    }
    
}

/*
extension ExpenseListVC: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = self.fetchedResultsController.sections
            else {
                return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchedResultsController.sections?[section]
            else {
                return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.cell.rawValue, for: indexPath) as! _ELVCCell
        cell.expense = self.fetchedResultsController.object(at: indexPath)
        return cell
    }
    
}

extension ExpenseListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewID.header.rawValue) as! _ELVCSectionHeader
        headerView.dateString = self.fetchedResultsController.sections?[section].name
        if let computedTotal = self.totalCache.object(forKey: NSNumber(value: section)) {
            headerView.sectionTotal = computedTotal
        } else {
            headerView.sectionTotal = self.computeAndCacheTotal(for: section)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 24
    }
    
}
 
 */
