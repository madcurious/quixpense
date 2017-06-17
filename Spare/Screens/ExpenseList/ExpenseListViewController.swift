//
//  ExpenseListViewController.swift
//  Spare
//
//  Created by Matt Quiros on 16/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData
import Mold

fileprivate enum ViewID: String {
    case cell = "cell"
}

class ExpenseListViewController: UIViewController {
    
    let loadableView = LoadableView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let group: ExpenseGroup
    var expenses = [Expense]()
    
    init(group: ExpenseGroup) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.group.groupName
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.loadableView.dataViewContainer.addSubviewAndFill(self.tableView)
        self.view = self.loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(Value1TableViewCell.self, forCellReuseIdentifier: ViewID.cell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.fetchExpenses()
    }
    
    func fetchExpenses() {
        self.loadableView.state = .loading
        
        let sectionIdentifier = self.group.sectionIdentifier
        
        switch self.group {
        case .category(_):
            let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "%K == %@ AND %K == %@",
                                                 sectionIdentifier.keyPath,
                                                 sectionIdentifier.value,
                                                 #keyPath(Expense.category),
                                                 self.group.classifier
            )
            fetchRequest.sortDescriptors = [
                NSSortDescriptor(key: #keyPath(Expense.dateCreated), ascending: false)
            ]
            do {
                self.expenses = try Global.coreDataStack.viewContext.fetch(fetchRequest)
                self.tableView.reloadData()
                self.loadableView.state = .data
            } catch {
                self.loadableView.state = .error(error)
            }
            
        case .tag(let tagGroup):
            if let set = tagGroup.value(forKey: "expenses") as? NSSet,
                let unsortedExpenses = set.allObjects as? [Expense] {
                let sortedExpenses = unsortedExpenses.sorted(by: {
                    ($0.dateCreated! as Date).compare($1.dateCreated! as Date) == .orderedDescending
                })
                self.expenses = sortedExpenses
                self.tableView.reloadData()
                self.loadableView.state = .data
            }
        }
    }
    
}

extension ExpenseListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.cell.rawValue, for: indexPath)
        
        cell.textLabel?.text = self.expenses[indexPath.row].displayText()
        cell.detailTextLabel?.text = AmountFormatter.displayText(for: self.expenses[indexPath.row].amount)
        
        return cell
    }
    
}

extension ExpenseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
