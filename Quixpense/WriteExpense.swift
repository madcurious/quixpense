//
//  WriteExpense.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

/**
 Adds an expense or edits an existing one with a given `NSManagedObjectID`.
 */
class WriteExpense: BROperation<NSManagedObjectID, Error> {
    
    let context: NSManagedObjectContext
    let validExpense: ValidExpense
    let objectId: NSManagedObjectID?
    
    init(context: NSManagedObjectContext, validExpense: ValidExpense, objectId: NSManagedObjectID?, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.validExpense = validExpense
        self.objectId = objectId
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        do {
            let expense: Expense
            if let objectId = objectId,
                let existing = context.object(with: objectId) as? Expense {
                expense = existing
            } else {
                expense = Expense(context: context)
                expense.dateCreated = Date() as NSDate
            }
            
            expense.amount = validExpense.amount
            expense.dateSpent = validExpense.dateSpent as NSDate
            expense.category = validExpense.category
            expense.tags = validExpense.tags
            for (key, value) in SectionIdentifier.makeAll(for: validExpense.dateSpent) {
                expense.setValue(value, forKey: key)
            }
            
            try context.saveToStore()
            result = .success(expense.objectID)
        } catch {
            result = .error(error)
        }
    }
    
}
