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
    case sectionHeader = "sectionHeader"
    case cell = "cell"
}

class ExpenseListViewController: UIViewController {
    
    let loadableView = LoadableView()
    let tableView = UITableView(frame: .zero, style: .plain)
    
    let group: NSManagedObject
    var expenses = [Expense]()
    
    init(group: NSManagedObject) {
        self.group = group
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.group.value(forKeyPath: "classifier.name") as? String
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.loadableView.dataViewContainer.addSubviewsAndFill(self.tableView)
        self.view = self.loadableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: ViewID.sectionHeader.rawValue)
        self.tableView.register(TwoLabelTableViewCell.nib(), forCellReuseIdentifier: ViewID.cell.rawValue)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.fetchExpenses()
    }
    
    func fetchExpenses() {
        self.loadableView.state = .loading
        
        if let set = self.group.value(forKey: "expenses") as? NSSet,
            let unsortedExpenses = set.allObjects as? [Expense] {
            let sortedExpenses = unsortedExpenses.sorted(by: {
                ($0.dateCreated! as Date).compare($1.dateCreated! as Date) == .orderedDescending
            })
            self.expenses = sortedExpenses
            self.tableView.reloadData()
            self.loadableView.state = .data
        } else {
            self.loadableView.state = .noData("Could not load expenses for this group.")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.cell.rawValue, for: indexPath) as! TwoLabelTableViewCell
        
        cell.leftLabel.text = self.expenses[indexPath.row].displayText()
        cell.rightLabel.text = AmountFormatter.displayText(for: self.expenses[indexPath.row].amount)
        
        return cell
    }
    
}

extension ExpenseListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let modalContainer = BaseNavBarVC(rootViewController: EditExpenseViewController(expenseId: expenses[indexPath.row].objectID))
        present(modalContainer, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 22
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let existingView = tableView.dequeueReusableHeaderFooterView(withIdentifier: ViewID.sectionHeader.rawValue)!
        let headerView: SectionTotalHeaderView
        
        if let existingHeader = existingView.subviews.first(where: {$0 is SectionTotalHeaderView}) as? SectionTotalHeaderView {
            headerView = existingHeader
        } else {
            headerView = SectionTotalHeaderView.instantiateFromNib()
            existingView.addSubviewsAndFill(headerView)
        }
        
        if let sectionIdentifier = self.group.value(forKey: "sectionIdentifier") as? String,
            let total = self.group.value(forKey: "total") as? NSDecimalNumber {
            headerView.sectionIdentifier = sectionIdentifier
            headerView.sectionTotal = total
        }
        
        return existingView
    }
    
}
