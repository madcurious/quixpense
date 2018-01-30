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
    let groupCache = NSCache<NSString, NSArray>() // NSCache<String, [[String : NSDecimalNumber]]>
    
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
    
    func total(for section: Int) -> NSDecimalNumber {
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
    
    func categories(for section: Int) -> [[String : NSDecimalNumber]] {
        guard let sectionName = fetchController.sections?[section].name as NSString?
            else {
                return []
        }
        
        if let existing = groupCache.object(forKey: sectionName) {
            let categories = existing.flatMap({ $0 as? [String : NSDecimalNumber] })
            return categories
        }
        
        let categories: [[String : NSDecimalNumber]] = {
            guard let expenses = fetchController.sections?[section].objects as? [Expense]
                else {
                    return []
            }
            let categoryNameAndExpenses = Dictionary(grouping: expenses, by: { $0.category! })
            let categoryNameAndTotal: [[String : NSDecimalNumber]] = categoryNameAndExpenses.flatMap({ (categoryName, expenses) in
                return [categoryName : expenses.reduce(NSDecimalNumber.zero, {$0.adding($1.amount ?? .zero)})]
            })
            return categoryNameAndTotal.sorted(by: { $0.first!.value > $1.first!.value })
        }()
        groupCache.setObject(categories as NSArray, forKey: sectionName)
        return categories
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
            return categories(for: section).count
        case .tags:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        let expense = fetchController.object(at: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = {
            switch filter.displayMode {
            case .expenses:
                return "\(AmountFormatter.string(from: expense.amount!)!)\n\(expense.dateSpent!)\n\(expense.category!)\n\(expense.tags!.joined(separator: ","))"
            case .categories:
                let data = categories(for: indexPath.section)[indexPath.row]
                return "\(data.first!.key) : \(AmountFormatter.string(from: data.first!.value)!)"
            case .tags:
                return nil
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
        view.total = total(for: section)
        return view
    }
    
}

// MARK: - FilterViewControllerDelegate
extension ExpensesViewController: FilterViewControllerDelegate {
    
    func filterViewController(_ filterViewController: FilterViewController, didSelect filter: Filter) {
        // Do nothing if the filter wasn't changed.
        guard self.filter != filter,
            filter.displayMode != .tags
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
