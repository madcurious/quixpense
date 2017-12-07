//
//  EditExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 28/08/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Bedrock

class EditExpenseOperation: BROperation<NSManagedObjectID, Error> {
    
    let context: NSManagedObjectContext
    let expenseId: NSManagedObjectID
    let details: ValidExpense
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, details: ValidExpense, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.expenseId = expenseId
        self.details = details
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        guard let expense = context.object(with: expenseId) as? Expense
            else {
                result = .error(BRError("The expense to edit no longer exists."))
                return
        }
        
        do {
            expense.amount = details.amount
            expense.dateSpent = details.dateSpent
            
            // Edit the category and category groups only if the category is changed.
            if let currentCategory = expense.category,
                currentCategory.name != details.category {
                currentCategory.removeFromExpenses(expense)
                let category = try ExpenseUtil.setCategory(for: expense, categoryName: details.category, in: context)
                
                // Remove the expense from its current category groups.
                for keyPath in ClassifierType.category.groupTypes.map({ $0.expenseKeyPath }) {
                    if let categoryGroup = expense.value(forKey: keyPath) as? ClassifierGroup {
                        ExpenseUtil.remove(expense: expense, fromClassifierGroup: categoryGroup)
                    }
                }
                try ExpenseUtil.setCategoryGroups(for: expense, category: category, in: context)
            }
        } catch {
            result = .error(error)
        }
    }
    
}


