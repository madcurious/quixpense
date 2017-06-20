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

class HomeViewController: UIViewController {
    
    let filterButton = FilterButton.instantiateFromNib()
    let loadableView = LoadableView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    var fetchedResultsController = Global.filter.makeFetchedResultsController()
    let sectionTotals = NSCache<NSString, NSDecimalNumber>()
    
    lazy var noDataText: NSAttributedString = {
        return NSAttributedString(attributedStrings:
            NSAttributedString(string: "No expenses found",
                               font: Global.theme.font(for: .infoLabelMainText),
                               textColor: Global.theme.color(for: .promptLabel)),
                                  NSAttributedString(string: "\n\nYou must go out and spend your\nmoney.",
                                                     font: Global.theme.font(for: .infoLabelSecondaryText),
                                                     textColor: Global.theme.color(for: .promptLabel)))
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
        self.loadableView.dataViewContainer.addSubviewsAndFill(self.tableView)
        self.view = self.loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.filterButton.addTarget(self, action: #selector(handleValueChangeOnFilterButton), for: .valueChanged)
        
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ViewID.sectionHeader.rawValue)
        self.tableView.register(TwoLabelTableViewCell.nib(), forCellReuseIdentifier: ViewID.groupCell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.performFetch()
    }
    
    func performFetch() {
        self.loadableView.state = .loading
        
        self.sectionTotals.removeAllObjects()
        
        do {
            try self.fetchedResultsController.performFetch()
            if let count = self.fetchedResultsController.fetchedObjects?.count,
                count == 0 {
                self.loadableView.state = .noData(self.noDataText)
            } else {
                self.tableView.reloadData()
                self.loadableView.state = .data
            }
        } catch {
            self.loadableView.state = .error(error)
        }
    }
    
    /// Computes for the section total which is displayed in the section header.
    func computeTotal(forSection section: Int) -> NSDecimalNumber {
        var runningTotal = NSDecimalNumber(value: 0)
        
        // For category groups, we simply add the total of each group.
        if Global.filter.grouping == .category,
            let categoryGroups = self.fetchedResultsController.sections?[section].objects as? [NSManagedObject] {
            categoryGroups.forEach({
                runningTotal += $0.value(forKey: "total") as! NSDecimalNumber
            })
        }
        
            // For tag groups, we need to add the amount of all the expenses in the section.
            // We can't simply add the totals of each tag group because expenses can have
            // multiple tags and can therefore appear in multiple tag groups.
        else if let tagGroups = self.fetchedResultsController.sections?[section].objects as? [NSManagedObject] {
            var expensesInSection = Set<Expense>()
            tagGroups.forEach { group in
                if let groupExpenses = group.value(forKey: "expenses") as? Set<Expense> {
                    groupExpenses.forEach({
                        if expensesInSection.contains($0) {
                            // Avoid counting the expense's amount if it has
                            // already been added before.
                            return
                        }
                        expensesInSection.insert($0)
                        runningTotal += $0.amount!
                    })
                }
            }
        }
        
        return runningTotal
    }
    
    func generateTextsForObject(at indexPath: IndexPath) -> (String?, String?) {
        if let group = self.fetchedResultsController.object(at: indexPath) as? NSManagedObject,
            let tagName = group.value(forKeyPath: "classifier.name") as? String,
            let total = group.value(forKey: "total") as? NSDecimalNumber {
            return (tagName, AmountFormatter.displayText(for: total))
        }
        return (nil, nil)
    }

}

// MARK: - Target actions
extension HomeViewController {
    
    @objc func handleValueChangeOnFilterButton() {
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
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ViewID.groupCell.rawValue) as! TwoLabelTableViewCell
        
        let (leftText, rightText) = self.generateTextsForObject(at: indexPath)
        cell.leftLabel.text = leftText
        cell.rightLabel.text = rightText
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let existingView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewID.sectionHeader.rawValue)!
        let headerView: SectionTotalHeaderView
            
        if let existingHeader = existingView.subviews.first(where: {$0 is SectionTotalHeaderView}) as? SectionTotalHeaderView {
            headerView = existingHeader
        } else {
            headerView = SectionTotalHeaderView.instantiateFromNib()
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
        
        guard let group = self.fetchedResultsController.object(at: indexPath) as? NSManagedObject
            else {
                return
        }
        let listScreen = ExpenseListViewController(group: group)
        self.navigationController?.pushViewController(listScreen, animated: true)
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
        self.tableView.reloadData()
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
