//
//  HomeViewController.swift
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
}

class HomeViewController: MDLoadableViewController {
    
    let filterButton = FilterButton.instantiateFromNib()
    let customView = HomeView.instantiateFromNib()
    
    var fetchedResultsController = Global.filter.makeFetchedResultsController()
    let sectionTotals = NSCache<NSString, NSDecimalNumber>()
    
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
        
        self.filterButton.addTarget(self, action: #selector(handleValueChangeOnFilterButton), for: .valueChanged)
        
        self.customView.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ViewID.sectionHeader.rawValue)
        self.customView.tableView.dataSource = self
        self.customView.tableView.delegate = self
        
        self.performFetch()
    }
    
    func performFetch() {
        self.showView(for: .loading)
        
        self.sectionTotals.removeAllObjects()
        
        do {
            try self.fetchedResultsController.performFetch()
            if let count = self.fetchedResultsController.fetchedObjects?.count,
                count == 0 {
                self.showView(for: .empty)
            } else {
                self.customView.tableView.reloadData()
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
        self.customView.tableView.isHidden = state != .data
    }
    
    /// Computes for the section total which is displayed in the section header.
    func computeTotal(forSection section: Int) -> NSDecimalNumber {
        var runningTotal = NSDecimalNumber(value: 0)
        
        if let dictionaries = self.fetchedResultsController.sections?[section].objects as? [[String : AnyObject]] {
            dictionaries.forEach({ (dictionary) in
                if let total = dictionary["total"] as? NSDecimalNumber {
                    runningTotal = runningTotal.adding(total)
                }
            })
        } else if let tagGroups = self.fetchedResultsController.sections?[section].objects as? [NSManagedObject] {
            var sectionExpenses = Set<Expense>()
            tagGroups.forEach { group in
//                if let groupTotal = group.value(forKey: "total") as? NSDecimalNumber {
//                    runningTotal = runningTotal.adding(groupTotal)
//                }
                if let groupExpenses = group.value(forKey: "expenses") as? Set<Expense> {
//                    sectionExpenses.formUnion(groupExpenses)
                    groupExpenses.forEach({ (expense) in
                        if sectionExpenses.contains(expense) {
                            return
                        }
                        sectionExpenses.insert(expense)
                        runningTotal = runningTotal.adding(expense.amount ?? 0)
                    })
                }
            }
//            return sectionExpenses.total()
        }
        
        return runningTotal
    }
    
    func generateLabelTextsForObject(at indexPath: IndexPath) -> (String?, String?) {
        if let tagGroup = self.fetchedResultsController.object(at: indexPath) as? NSManagedObject,
            let tagName = tagGroup.value(forKeyPath: "classifier.name") as? String,
            let total = tagGroup.value(forKey: "total") as? NSDecimalNumber {
            return (tagName, AmountFormatter.displayText(for: total))
        }
        
        else if
            let section = self.fetchedResultsController.sections?[indexPath.section],
            let sectionObjects = (section.objects as? [[String : AnyObject]])?.sorted(by: {
                ($0["total"] as! NSDecimalNumber).compare(($1["total"] as! NSDecimalNumber)) == .orderedDescending
            }),
            let categoryID = sectionObjects[indexPath.row]["categoryID"] as? NSManagedObjectID,
            let category = Global.coreDataStack.viewContext.object(with: categoryID) as? Category,
            let categoryName = category.name,
            let total = sectionObjects[indexPath.row]["total"] as? NSDecimalNumber {
            return (categoryName, AmountFormatter.displayText(for: total))
        }
        
        else {
            return (nil, nil)
        }
    }

}

// MARK: - Target actions
extension HomeViewController {
    
    func handleValueChangeOnFilterButton() {
        Global.filter = self.filterButton.filter
        self.fetchedResultsController = Global.filter.makeFetchedResultsController()
        self.performFetch()
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        self.performFetch()
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
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
        let cell: UITableViewCell
        
        if let existingCell = tableView.dequeueReusableCell(withIdentifier: ViewID.groupCell.rawValue) {
            cell = existingCell
        } else {
            cell = UITableViewCell(style: .value1, reuseIdentifier: ViewID.groupCell.rawValue)
            cell.accessoryType = .disclosureIndicator
            self.applyTheme(to: cell)
        }
        
        let (leftText, rightText) = self.generateLabelTextsForObject(at: indexPath)
        cell.textLabel?.text = leftText
        cell.detailTextLabel?.text = rightText
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let existingView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewID.sectionHeader.rawValue)!
        let headerView: HomeSectionHeader
            
        if let existingHeader = existingView.subviews.first(where: {$0 is HomeSectionHeader}) as? HomeSectionHeader {
            headerView = existingHeader
        } else {
            headerView = HomeSectionHeader.instantiateFromNib()
            existingView.addSubviewsAndFill(headerView)
        }
        
        if let sectionIdentifier = self.fetchedResultsController.sections?[section].name {
            headerView.sectionIdentifier = self.fetchedResultsController.sections?[section].name
            headerView.sectionTotal = {
                if let total = self.sectionTotals.object(forKey: sectionIdentifier as NSString) {
                    return total
                } else {
                    let total = self.computeTotal(forSection: section)
                    self.sectionTotals.setObject(total, forKey: sectionIdentifier as NSString)
                    return total
                }
            }()
        }
        
        return existingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
}

// MARK: - Themeable
extension HomeViewController: Themeable {
    
    func applyTheme() {
        self.customView.tableView.reloadData()
    }
    
    func applyTheme(to tableViewCell: UITableViewCell) {
        tableViewCell.contentView.backgroundColor = Global.theme.color(for: .mainBackground)
        
        guard let leftLabel = tableViewCell.textLabel,
            let rightLabel = tableViewCell.detailTextLabel
            else {
                return
        }
        
        leftLabel.font = Global.theme.font(for: .regularText)
        leftLabel.textColor = Global.theme.color(for: .regularText)
        
        rightLabel.font = Global.theme.font(for: .regularText)
        rightLabel.textColor = Global.theme.color(for: .regularText)
    }
    
}
