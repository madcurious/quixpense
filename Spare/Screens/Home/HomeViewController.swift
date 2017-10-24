//
//  HomeViewController.swift
//  Spare
//
//  Created by Matt Quiros on 03/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import Bedrock
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
                               font: Global.theme.font(for: .loadableViewInfoLabelMainText),
                               textColor: Global.theme.color(for: .promptLabel)),
                                  NSAttributedString(string: "\n\nYou must go out and spend your\nmoney.",
                                                     font: Global.theme.font(for: .loadableViewInfoLabelSecondaryText),
                                                     textColor: Global.theme.color(for: .promptLabel)))
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    func initialize() {
        tabBarItem.image = UIImage.template(named: "tabIconExpenseList")
        navigationItem.titleView = filterButton
    }
    
    override func loadView() {
        loadableView.dataViewContainer.addSubviewsAndFill(tableView)
        view = loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.addTarget(self, action: #selector(handleValueChangeOnFilterButton), for: .valueChanged)
        
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ViewID.sectionHeader.rawValue)
        tableView.register(TwoLabelTableViewCell.nib(), forCellReuseIdentifier: ViewID.groupCell.rawValue)
        tableView.dataSource = self
        tableView.delegate = self
        
        performFetch()
        
        fetchedResultsController.delegate = self
    }
    
    func performFetch() {
        loadableView.state = .loading
        
        sectionTotals.removeAllObjects()
        
        do {
            try fetchedResultsController.performFetch()
            if let count = fetchedResultsController.fetchedObjects?.count,
                count == 0 {
                loadableView.state = .noData(["message" : noDataText])
            } else {
                tableView.reloadData()
                loadableView.state = .data
            }
        } catch {
            loadableView.state = .error(error)
        }
    }
    
    /// Computes for the section total which is displayed in the section header.
    func computeTotal(forSection section: Int) -> NSDecimalNumber {
        var runningTotal = NSDecimalNumber(value: 0)
        
        // For category groups, we simply add the total of each group.
        if Global.filter.grouping == .category,
            let categoryGroups = fetchedResultsController.sections?[section].objects as? [NSManagedObject] {
            categoryGroups.forEach({
                runningTotal += $0.value(forKey: "total") as! NSDecimalNumber
            })
        }
        
            // For tag groups, we need to add the amount of all the expenses in the section.
            // We can't simply add the totals of each tag group because expenses can have
            // multiple tags and can therefore appear in multiple tag groups.
        else if let tagGroups = fetchedResultsController.sections?[section].objects as? [NSManagedObject] {
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
        if let group = fetchedResultsController.object(at: indexPath) as? NSManagedObject,
            let tagName = group.value(forKeyPath: "classifier.name") as? String,
            let total = group.value(forKey: "total") as? NSDecimalNumber {
            return (tagName, AmountFormatter.displayText(for: total))
        }
        return (nil, nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        filterButton.setNeedsUpdateConstraints()
    }

}

// MARK: - Target actions
extension HomeViewController {
    
    @objc func handleValueChangeOnFilterButton() {
        Global.filter = filterButton.filter
        fetchedResultsController = Global.filter.makeFetchedResultsController()
        fetchedResultsController.delegate = self
        performFetch()
    }
    
}

// MARK: - NSFetchedResultsControllerDelegate
extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        performFetch()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        performFetch()
    }
    
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections
            else {
                return 0
        }
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section]
            else {
                return 0
        }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.groupCell.rawValue) as! TwoLabelTableViewCell
        
        let (leftText, rightText) = generateTextsForObject(at: indexPath)
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
        
        if let sectionIdentifier = fetchedResultsController.sections?[section].name {
            headerView.sectionIdentifier = fetchedResultsController.sections?[section].name
            headerView.sectionTotal = {
                if let total = sectionTotals.object(forKey: sectionIdentifier as NSString) {
                    return total
                } else {
                    let total = computeTotal(forSection: section)
                    sectionTotals.setObject(total, forKey: sectionIdentifier as NSString)
                    return total
                }
            }()
        }
        
        return existingView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let group = fetchedResultsController.object(at: indexPath) as? NSManagedObject
            else {
                return
        }
        let listScreen = ExpenseListViewController(group: group)
        navigationController?.pushViewController(listScreen, animated: true)
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
        tableView.reloadData()
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
