//
//  ExpenseListVC.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold

class ExpenseListVC: MDOperationViewController {
    
    var category: Category
    let startDate: NSDate
    let endDate: NSDate
    
    var expenses: [Expense]?
    var total = NSDecimalNumber(integer: 0)
    var percent = Double(0)
    
    let headerView = __ELVCHeaderView.instantiateFromNib()
    let tableView = UITableView(frame: CGRectZero, style: .Plain)
    
    override var loadingView: UIView {
        return OperationVCLoadingView()
    }
    
    override var primaryView: UIView {
        return self.tableView
    }
    
    init(category: Category, startDate: NSDate, endDate: NSDate) {
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
        self.tableView.separatorStyle = .None
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
                
                self.setupHeaderView()
                
                self.showView(.Primary)
            })
    }
    
    override func viewWillAppear(animated: Bool) {
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
