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
    
    /**
     Returns all the expenses within the summary's period. This invokes the fetched property `expenses`
     defined in the managed object model.
     */
    @NSManaged var expenses: [Expense]?
    
    /**
     Returns all the categories in the same MOC as the summary.
     */
    var categories: [Category]? {
        do {
            let request = NSFetchRequest(entityName: Category.entityName)
            if let categories = try self.managedObjectContext?.executeFetchRequest(request) as? [Category] {
                return categories
            }
        } catch {
            // throw Error.AppUnknownError
        }
        return nil
    }
    
    /**
     Returns a dictionary of all categories and their totals based on the expenses in the summary's period.
     Potentially an expensive computed property, so call conscientiously.
     */
    var categoryTotals: [Category : NSDecimalNumber]? {
        guard let categories = self.categories,
            let expenses = self.expenses
            else {
                return nil
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
            
            totals[category] = expenses.map({ $0.amount ?? NSDecimalNumber(integer: 0) }).reduce(0, combine: +)
        }
        
        return totals
    }
    
    /**
     Returns the total of all the categories' totals, or all the expenses.
     */
    var total: NSDecimalNumber {
        guard let expenses = self.expenses
            else {
                return NSDecimalNumber(integer: 0)
        }
        
        return expenses.map({ $0.amount ?? NSDecimalNumber(integer: 0)}).reduce(0, combine: +)
    }

}


extension Summary: CoreDataModelable {
    
    static var entityName: String {
        return "Summary"
    }
    
}
