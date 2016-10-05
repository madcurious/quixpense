//
//  ValidateExpenseOperation.swift
//  Spare
//
//  Created by Matt Quiros on 12/05/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import UIKit
import Mold
import BNRCoreDataStack

class ValidateExpenseOperation: MDOperation {
    
    var expenseID: NSManagedObjectID
    var parentContext: NSManagedObjectContext?
    
    init(expense: Expense) {
        self.expenseID = expense.objectID
        self.parentContext = expense.managedObjectContext
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = self.parentContext
        let expense = context.object(with: self.expenseID) as! Expense
        
        // Put all the labels and values in an array for simplicity, then loop
        // through it looking for empty values.
        let requiredFields: [(String, Any?)] = [
            ("Amount", expense.amount),
            ("Category", expense.category),
            ("Date spent", expense.dateSpent),
            ("Payment method", expense.paymentMethod)
        ]
        for (label, value) in requiredFields {
            if value == nil {
                throw Error.userEnteredInvalidValue("\(label) is required.")
            }
        }
        
        if let amount = expense.amount
            , amount == 0 {
            throw Error.userEnteredInvalidValue("You can't add zero-amount expenses.")
        }
        
        return nil
    }
    
}
