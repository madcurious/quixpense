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
    
    private let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = true
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
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
        
        customView.showsDeleteView = true
        refreshFromSavedValues()
    }
    
    func refreshFromSavedValues() {
        guard let expense = Global.coreDataStack.viewContext.object(with: expenseId) as? Expense
            else {
                return
        }
        
        if let amount = expense.amount {
            let amountText = decimalFormatter.string(from: amount)
            customView.amountFieldView.textField.text = amountText
            rawExpense.amount = amountText
        }
        
        if let dateSpent = expense.dateSpent {
            customView.dateFieldView.setDate(dateSpent)
            rawExpense.dateSpent = dateSpent
        }
        
        if let category = expense.category {
            let categorySelection = CategorySelection.existing(category.objectID)
            customView.categoryFieldView.setCategory(categorySelection)
            rawExpense.categorySelection = categorySelection
        }
        
        if let tags = expense.tags {
            let tagSelection = TagSelection(from: tags)
            customView.tagFieldView.setTags(tagSelection)
            rawExpense.tagSelection = tagSelection
        }
    }
    
    override func handleTapOnCancelButton() {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
}
