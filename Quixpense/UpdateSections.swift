//
//  UpdateSections.swift
//  Quixpense
//
//  Created by Matt Quiros on 22/01/2018.
//  Copyright © 2018 Matt Quiros. All rights reserved.
//

import Foundation
import Bedrock
import CoreData

class UpdateSections: BROperation<Int, Error> {
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext, completion: BROperationCompletionBlock?) {
        self.context = context
        super.init(completionBlock: completion)
    }
    
    override func main() {
        let request: NSFetchRequest<Expense> = Expense.fetchRequest()
        do {
            let expenses = try context.fetch(request)
            var count = 0
            for expense in expenses {
                if isCancelled {
                    return
                }
                
                guard let dateSpent = expense.dateSpent as Date?
                    else {
                        throw BRError("Unexpected error: stored expense does no thave a date spent.")
                }
                for (key, value) in SectionIdentifier.makeAll(for: dateSpent) {
                    expense.setValue(value, forKey: key)
                }
                count += 1
            }
            result = .success(count)
        } catch {
            result = .error(error)
        }
    }
    
}
