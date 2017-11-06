//
//  DeleteExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 02/11/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

class DeleteExpenseOperation: BROperation<NSManagedObjectID, Error> {
    
    let context: NSManagedObjectContext
    let expenseId: NSManagedObjectID
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.expenseId = expenseId
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        guard let expense = context.object(with: expenseId) as? Expense
            else {
                result = .error(BRError("Expense with ID \(expenseId) not found."))
                return
        }
        
        var classifierGroups: [ClassifierGroup?] = [
            expense.dayCategoryGroup,
            expense.weekCategoryGroup,
            expense.monthCategoryGroup
        ]
        let tagGroupKeyPaths = [
            #keyPath(Expense.dayTagGroups),
            #keyPath(Expense.weekTagGroups),
            #keyPath(Expense.monthTagGroups)
        ]
        for keyPath in tagGroupKeyPaths {
            if let set = expense.value(forKey: keyPath) as? NSSet {
                let groups = set.map({ $0 as? ClassifierGroup })
                classifierGroups.append(contentsOf: groups)
            }
        }
        
        for group in classifierGroups {
            if let group = group {
                group.removeFromExpenses(expense)
                group.total = group.total?.subtracting(expense.amount ?? 0)
                if group.expenses?.count == 0 {
                    context.delete(group)
                }
            }
        }
        context.delete(expense)
        
        do {
            try context.saveToStore()
            result = .success(expenseId)
        } catch {
            result = .error(error)
        }
    }
    
}
