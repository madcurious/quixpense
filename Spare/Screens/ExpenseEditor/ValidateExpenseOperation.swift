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
    
    override func buildResult(object: Any?) throws -> Any? {
        let context = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
        context.parentContext = self.parentContext
        
        let request = NSFetchRequest(entityName: Expense.entityName)
        request.predicate = NSPredicate(format: "objectID == \(self.expenseID)")
        
        guard let expense = try context.executeFetchRequest(request).first as? Expense
            else {
                throw Error.AppUnknownError
        }
        
        if nonEmptyString(expense.itemDescription) == nil {
            throw Error.UserEnteredInvalidValue("You must enter a description.")
        }
        
        if expense.amount == nil {
            throw Error.UserEnteredInvalidValue("You must enter the amount.")
        }
        
        return nil
    }
    
}
