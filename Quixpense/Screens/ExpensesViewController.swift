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
    let fetchController: NSFetchedResultsController<Expense>
    let loadableView = BRDefaultLoadableView(frame: .zero)
    let tableView = UITableView(frame: .zero, style: .plain)
    
    enum ViewId: String {
        case cell = "cell"
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
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        
        do {
            loadableView.state = .loading
            try fetchController.performFetch()
            
            if fetchController.sections?.isEmpty ?? false {
                
            } else {
                tableView.dataSource = self
                tableView.delegate = self
                tableView.register(UITableViewCell.self, forCellReuseIdentifier: ViewId.cell.rawValue)
                tableView.reloadData()
                loadableView.state = .success
            }
        } catch {
            loadableView.state = .error(error)
        }
    }
    
}

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

extension ExpensesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return fetchController.sections?[section].name ?? "Unnamed"
    }
    
}
