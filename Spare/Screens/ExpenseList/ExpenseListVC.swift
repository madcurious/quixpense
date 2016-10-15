//
//  ExpenseListVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

private enum ViewID: String {
    case Cell = "Cell"
}

class ExpenseListVC: MDOperationViewController {
    
    var category: Category
    let startDate: Date
    let endDate: Date
    
    var expenses: [Expense]?
    var total = NSDecimalNumber(value: 0 as Int)
    var percent = Double(0)
    
    let headerView = __ELVCHeaderView.instantiateFromNib()
    let tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    override var loadingView: UIView {
        return OperationVCLoadingView()
    }
    
    override var primaryView: UIView {
        return self.tableView
    }
    
    init(category: Category, startDate: Date, endDate: Date) {
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
        super.init()
        self.title = "Expenses"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        glb_applyGlobalVCSettings(self)
        
        self.tableView.backgroundColor = Color.UniversalBackgroundColor
        self.tableView.separatorStyle = .none
        self.tableView.estimatedRowHeight = 44
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(__ELVCCell.nib(), forCellReuseIdentifier: ViewID.Cell.rawValue)
    }
    
    func setupHeaderView() {
        self.headerView.nameLabel.text = self.category.name
        self.headerView.totalLabel.text = AmountFormatter.displayTextForAmount(self.total)
        self.headerView.detailLabel.text = PercentFormatter.displayTextForPercent(self.percent) + " of " + DateFormatter.displayTextForStartDate(self.startDate, endDate: self.endDate)
        
        self.headerView.setNeedsLayout()
        self.headerView.layoutIfNeeded()
        self.tableView.tableHeaderView = self.headerView
    }
    
    override func buildOperation() -> MDOperation? {
        return GetExpensesOperation(category: self.category, startDate: self.startDate, endDate: self.endDate)
            .onSuccess({[unowned self] result in
                guard let (expenses, total, percent) = result as? ([Expense], NSDecimalNumber, Double)
                    else {
                        return
                }
                
                self.expenses = expenses
                self.total = total
                self.percent = percent
                
                if expenses.count > 0 {
                    self.setupHeaderView()
                    self.tableView.reloadData()
                    self.showView(.primary)
                } else {
                    self.showView(.noResults)
                }
            })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Fixes that crappy iOS bug where partially dragging from the left side
        // hides the navigation bar.
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ExpenseListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let expenses = self.expenses
            else {
                return 0
        }
        return expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ViewID.Cell.rawValue) as! __ELVCCell
        cell.expense = self.expenses?[(indexPath as NSIndexPath).row]
        return cell
    }
    
}

extension ExpenseListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        if let expense = self.expenses?[(indexPath as NSIndexPath).row] {
            let modal = BaseNavBarVC(rootViewController: EditExpenseVC(expense: expense))
            self.navigationController?.present(modal, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
