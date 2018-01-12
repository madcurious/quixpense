//
//  DeleteExpense.swift
//  Quixpense
//
//  Created by Matt Quiros on 12/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import CoreData
import Bedrock

class DeleteExpense: BROperation<Bool, Error> {
    
    let context: NSManagedObjectContext
    let objectId: NSManagedObjectID
    
    init(context: NSManagedObjectContext, objectId: NSManagedObjectID, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.objectId = objectId
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        do {
            if let expense = context.object(with: objectId) as? Expense {
                context.delete(expense)
                try context.saveToStore()
            }
            result = .success(true)
        } catch {
            result = .error(error)
        }
    }
    
}
