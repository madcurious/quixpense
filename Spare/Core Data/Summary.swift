//
//  Summary.swift
//  
//
//  Created by Matt Quiros on 11/05/2016.
//
//

import Foundation
import CoreData
import BNRCoreDataStack
import Mold

class Summary: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func computeTotals() throws -> [Category : NSDecimalNumber] {
        guard let categories = try self.managedObjectContext?.executeFetchRequest(NSFetchRequest(entityName: Category.entityName)) as? [Category],
            let expenses = self.valueForKey("expenses") as? [Expense]
            else {
                throw Error.AppUnknownError
        }
        
        let groups = expenses.group({ $0.category })
        var totals: [Category : NSDecimalNumber] = [:]
        for category in categories {
            // If the category isn't in the grouping dictionary, then it doesn't have any expenses 
            // and its total should be set to 0.
            guard let expenses = groups[category]
                else {
                    totals[category] = 0
                    continue
            }
            
            totals[category] = expenses.reduce(NSDecimalNumber(integer: 0), combine: {(runningTotal, expense) in
                return (runningTotal ?? NSDecimalNumber(integer: 0)).decimalNumberByAdding(expense.amount ?? NSDecimalNumber(integer: 0))
            })
        }
        
        return totals
    }

}


extension Summary: CoreDataModelable {
    
    static var entityName: String {
        return "Summary"
    }
    
}