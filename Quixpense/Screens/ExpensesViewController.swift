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
    let groupCache = NSCache<NSString, NSArray>()
    
    let filterButton = BRLabelButton(frame: .zero)
    var filter = Filter.default
    
    enum ViewId: String {
        case cell = "cell"
        case sectionHeader = "sectionHeader"
    }
    
    init(container: NSPersistentContainer) {
        self.container = container
        self.fetchController = {
            let request: NSFetchRequest<Expense> = Expense.fetchRequest()
            request.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Expense.dateCreated), ascending: false)
            ]
            return NSFetchedResultsController(fetchRequest: request,
                                              managedObjectContext: container.viewContext,
                                              sectionNameKeyPath: #keyPath(Expense.daySectionId),
                                              cacheName: "cache")
        }()
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
        
        do {
            loadableView.state = .loading
            try fetchController.performFetch()
            
            if fetchController.sections?.isEmpty ?? false {
                
            } else {
                tableView.dataSource = self
                tableView.delegate = self
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
                tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: ViewId.sectionHeader.rawValue)
                tableView.reloadData()
                loadableView.state = .success
            }
        } catch {
            loadableView.state = .error(error)
        }
    }
    
}

// MARK: - Helpers
extension ExpensesViewController {
    
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
        guard let expenses = fetchController.sections?[section].objects as? [Expense]
            else {
                return .zero
        }
        return expenses.reduce(NSDecimalNumber.zero, { $0.adding($1.amount ?? .zero) })
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
        return fetchController.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewId.cell.rawValue, for: indexPath)
        let expense = fetchController.object(at: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = "\(expense.amount!)\n\(expense.dateSpent!)\n\(expense.category!)\n\(expense.tags!.joined(separator: ","))"
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
        
        // Rebuild the fetch controller.
        
        // Reload data.
    }
    
}
