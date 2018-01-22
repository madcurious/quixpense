//
//  ExpensesViewController.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

class ExpensesViewController: UIViewController {
    
    let container: NSPersistentContainer
    let fetchController: NSFetchedResultsController<Expense>
    let tableView = UITableView(frame: .zero, style: .plain)
    
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
        view = tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
    }
    
}
