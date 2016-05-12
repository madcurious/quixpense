//
//  ExpenseEditorVC.swift
//  Spare
//
//  Created by Matt Quiros on 03/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import BNRCoreDataStack

class ExpenseEditorVC: BaseVC {
    
    let customView = __EEVCView.instantiateFromNib() as __EEVCView
    
    var managedObjectContext: NSManagedObjectContext
    var expense: Expense
    
    init(expense: Expense?) {
        self.managedObjectContext = App.state.coreDataStack.newBackgroundWorkerMOC()
        if let expense = expense {
            self.expense = expense
        } else {
            self.expense = Expense(managedObjectContext: self.managedObjectContext)
        }
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func reset() {
        let expense = Expense(managedObjectContext: self.managedObjectContext)
        expense.itemDescription = nil
        expense.amount = nil
        expense.dateSpent = NSDate()
        expense.category = nil
        expense.paymentMethod = PaymentMethod(self.customView.paymentMethodControl.selectedSegmentIndex).rawValue
        self.expense = expense
    }
    
}
