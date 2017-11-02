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

class DeleteExpenseOperation: BROperation<Bool, Error> {
    
    let context: NSManagedObjectContext
    let expenseId: NSManagedObjectID
    
    init(context: NSManagedObjectContext, expenseId: NSManagedObjectID, completionBlock: BROperationCompletionBlock?) {
        self.context = context
        self.expenseId = expenseId
        super.init(completionBlock: completionBlock)
    }
    
    override func main() {
        
    }
    
}
