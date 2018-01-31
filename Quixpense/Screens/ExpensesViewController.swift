//
//  ExpensesViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Bedrock

class ExpensesViewController: UIViewController {
    
    let container: NSPersistentContainer
    var fetchController: NSFetchedResultsController<Expense>
    let loadableView = BRDefaultLoadableView(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .plain)
    let totalCache = NSCache<NSString, NSDecimalNumber>()
    
    // The cache used as the data source when the filter displays classifiers (categories or tags).
    // The key is the section name, and the array contains the classifiers and their totals.
    let groupCache = NSCache<NSString, NSArray>()
    
    let filterButton = BRLabelButton(frame: .zero)
    var filter = Filter.default
    
    enum ViewId: String {
        case cell = "cell"
        case sectionHeader = "sectionHeader"
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.fetchController = ExpensesViewController.makeFetchController(from: filter, firstWeekday: Calendar.current.firstWeekday, context: container.viewContext)
        super.init(nibName: nil, bundle: nil)
        title = "Expenses"
        tabBarItem.image = UIImage.template(named: "tabIconExpenses")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        loadableView.dataView.addSubviewsAndFill(tableView)
        view = loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterButton.titleLabel.font = .boldSystemFont(ofSize: UIFont.buttonFontSize)
        filterButton.titleLabel.text = "All expenses, daily"
        filterButton.addTarget(self, action: #selector(handleTapOnFilterButton), for: .touchUpInside)
        navigationItem.titleView = filterButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ViewId.sectionHeader.rawValue)
        
        fetchExpenses()
    }
    
}

// MARK: - Helpers
fileprivate extension ExpensesViewController {
    
    func fetchExpenses() {
        do {
            loadableView.state = .loading
            try fetchController.performFetch()
            
            if fetchController.sections?.isEmpty ?? false {
                loadableView.state = .empty(nil)
            } else {
                tableView.reloadData()
                loadableView.state = .success
            }
        } catch {
            loadableView.state = .error(error)
        }
    }
    
    func cachedTotal(for section: Int) -> NSDecimalNumber {
        guard let sectionName = fetchController.sections?[section].name as NSString?
            else {
                return .zero
        }
        
        // If the total exists, return the cached value.
        if let existing = totalCache.object(forKey: sectionName) {
            return existing
        }
        
        // Otherwise, compute for the total.
        let total: NSDecimalNumber = {
            if let expenses = fetchController.sections?[section].objects as? [Expense] {
                return expenses.reduce(NSDecimalNumber.zero, { $0.adding($1.amount ?? .zero) })
            }
            return .zero
        }()
        totalCache.setObject(total, forKey: sectionName)
        return total
    }
    
    func cachedCategoryTotals(for section: Int) -> [(name: String, total: NSDecimalNumber)] {
        guard let sectionName = fetchController.sections?[section].name as NSString?
            else {
                return []
        }
        // If there's an existing array of totals, return it.
        if let existing = groupCache.object(forKey: sectionName) as? [(String, NSDecimalNumber)] {
            return existing
        }
        
        // Otherwise, compute for the totals, cache it, then return it.
        let categoryTotals: [(String, NSDecimalNumber)] = {
            guard let expenses = fetchController.sections?[section].objects as? [Expense]
                else {
                    return []
            }
            let groupingByCategory = Dictionary(grouping: expenses, by: { $0.category ?? Classifier.category.default })
            let categoryTotals = groupingByCategory
                .flatMap({ ($0.key, $0.value.reduce(NSDecimalNumber.zero, {$0.adding($1.amount ?? .zero)})) })
                .sorted(by: { $0.1 > $1.1 })
            return categoryTotals
        }()
        groupCache.setObject(categoryTotals as NSArray, forKey: sectionName)
        return categoryTotals
    }
    
    func cachedTagTotals(for section: Int) -> [(name: String, total: NSDecimalNumber)] {
        guard let sectionName = fetchController.sections?[section].name as NSString?
            else {
                return []
        }
        // If there's an existing array of totals, return it.
        if let existing = groupCache.object(forKey: sectionName) as? [(String, NSDecimalNumber)] {
            return existing
        }
        
        // Otherwise, compute for the totals, cache it, then return it.
        let tagTotals: [(String, NSDecimalNumber)] = {
            guard let expenses = fetchController.sections?[section].objects as? [Expense]
                else {
                    return []
            }
            var groupingByTag = [String : Set<Expense>]()
            for expense in expenses {
                let tags = expense.tags ?? [Classifier.tag.default]
                for tag in tags {
                    if var existingSet = groupingByTag[tag] {
                        existingSet.insert(expense)
                    } else {
                        groupingByTag[tag] = Set([expense])
                    }
                }
            }
            let tagTotals = groupingByTag
                .flatMap({ ($0.key, $0.value.reduce(NSDecimalNumber.zero, {$0.adding($1.amount ?? .zero)})) })
                .sorted(by: { $0.1 > $1.1 })
            return tagTotals
        }()
        groupCache.setObject(tagTotals as NSArray, forKey: sectionName)
        return tagTotals
    }
    
    class func makeFetchController(from filter: Filter, firstWeekday: Int, context: NSManagedObjectContext) -> NSFetchedResultsController<Expense> {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(Expense.dateCreated), ascending: false)]
        let sectionKeyPath: String = {
            switch filter.period {
            case .day:
                return #keyPath(Expense.daySectionId)
            case .week:
                switch firstWeekday {
                case 2:
                    return #keyPath(Expense.weekSectionIdMonday)
                case 7:
                    return #keyPath(Expense.weekSectionIdSaturday)
                default:
                    return #keyPath(Expense.weekSectionIdSunday)
                }
            case .month:
                return #keyPath(Expense.monthSectionId)
            }
        }()
        return NSFetchedResultsController(fetchRequest: request,
                                          managedObjectContext: context,
                                          sectionNameKeyPath: sectionKeyPath,
                                          cacheName: "cache")
    }
    
}

// MARK: - Target actions
@objc extension ExpensesViewController {
    
    func handleTapOnFilterButton() {
        FilterViewController.present(from: self, initialSelection: filter, delegate: self)
    }
    
}

// MARK: - UITableViewDataSource
extension ExpensesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch filter.displayMode {
        case .expenses:
            return fetchController.sections?[section].numberOfObjects ?? 0
        case .categories:
            return cachedCategoryTotals(for: section).count
        case .tags:
            return cachedTagTotals(for: section).count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = {
            switch filter.displayMode {
            case .expenses:
                let expense = fetchController.object(at: indexPath)
                return "\(AmountFormatter.string(from: expense.amount!)!)\n\(expense.dateSpent!)\n\(expense.category!)\n\(expense.tags!.joined(separator: ","))"
            case .categories:
                let category = cachedCategoryTotals(for: indexPath.section)[indexPath.row]
                return "\(category.name) : \(AmountFormatter.string(from: category.total)!)"
            case .tags:
                let tag = cachedTagTotals(for: indexPath.section)[indexPath.row]
                return "\(tag.name) : \(AmountFormatter.string(from: tag.total)!)"
            }
        }()
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension ExpensesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewId.sectionHeader.rawValue) as? SectionHeaderView
            else {
                return nil
        }
        view.sectionIdentifier = fetchController.sections?[section].name
        view.total = cachedTotal(for: section)
        return view
    }
    
}

// MARK: - FilterViewControllerDelegate
extension ExpensesViewController: FilterViewControllerDelegate {
    
    func filterViewController(_ filterViewController: FilterViewController, didSelect filter: Filter) {
        // Do nothing if the filter wasn't changed.
        guard self.filter != filter
            else {
                return
        }
        
        self.filter = filter
        filterButton.titleLabel.text = filter.title
        filterButton.setNeedsLayout()
        filterButton.layoutIfNeeded()
        
        // Purge the caches.
        totalCache.removeAllObjects()
        groupCache.removeAllObjects()
        
        // Rebuild the fetch controller.
        fetchController = ExpensesViewController.makeFetchController(from: filter, firstWeekday: Calendar.current.firstWeekday, context: container.viewContext)
        
        // Reload data.
        fetchExpenses()
    }
    
}
