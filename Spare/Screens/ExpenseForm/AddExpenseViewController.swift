//
//  AddExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 23/06/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit

class AddExpenseViewController: UIViewController {
    
    let expenseForm = ExpenseFormViewController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Add"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.embedChildViewController(self.expenseForm, toView: self.view)
    }
    
}
