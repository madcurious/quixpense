//
//  EditExpenseViewController.swift
//  Spare
//
//  Created by Matt Quiros on 24/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import UIKit
import CoreData

class EditExpenseViewController: ExpenseFormViewController {
    
    let expenseId: NSManagedObjectID
    
    init(expenseId: NSManagedObjectID) {
        self.expenseId = expenseId
        super.init()
        self.title = "EDIT"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshFromSavedValues()
    }
    
    func refreshFromSavedValues() {
        guard let expense = Global.coreDataStack.viewContext.object(with: expenseId) as? Expense
            else {
                return
        }
        
        let amountText = AmountFormatter.displayText(for: expense.amount)
        customView.amountFieldView.textField.text = amountText
        enteredExpense.amount = amountText
        
        if let dateSpent = expense.dateSpent {
            customView.dateFieldView.setDate(dateSpent)
            enteredExpense.date = dateSpent
        }
        if let category = expense.category {
            let categorySelection = CategorySelection.id(category.objectID)
            customView.categoryFieldView.setCategory(categorySelection)
            enteredExpense.category = categorySelection
        }
        if let tags = expense.tags {
            let tagSelection = TagSelection(from: tags)
            customView.tagFieldView.setTags(tagSelection)
            enteredExpense.tags = tagSelection
        }
    }
    
    override func handleTapOnCancelButton() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}
