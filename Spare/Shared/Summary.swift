//
//  Summary.swift
//  Spare
//
//  Created by Matt Quiros on 14/06/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import BNRCoreDataStack
import Mold

struct Summary {
    
    var startDate: NSDate
    var endDate: NSDate
    var periodization: Periodization
    
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        formatter.dateFormat = "EEE, MMM d"
        return formatter
    }()
    
    /**
     Returns an array of all the expenses in the date range, or nil if none were found.
     */
    var expenses: [Expense]? {
        return glb_protect({
            let request = NSFetchRequest(entityName: Expense.entityName)
            request.predicate = NSPredicate(format: "dateSpent >= %@ AND dateSpent <= %@", self.startDate, self.endDate)
            if let expenses = try App.state.mainQueueContext.executeFetchRequest(request) as? [Expense]
                where expenses.isEmpty == false {
                return expenses
            }
            return nil
        })
    }
    
    /**
     Returns the total of all the expenses in this date range.
     */
    var total: NSDecimalNumber {
        guard let expenses = self.expenses
            else {
                return 0
        }
        
        return glb_totalOfExpenses(expenses)
    }
    
    /**
     Returns an array of the category, their totals, and their percent of the total.
     The array is ordered by biggest total first.
     */
    var info: [(Category, NSDecimalNumber, Double)]? {
        guard let categories = glb_allCategories()
            else {
                return nil
        }
        
        let overallTotal = self.total
        let groups = self.expenses?.groupBy({ $0.category })
        var info = [(Category, NSDecimalNumber, Double)]()
        for category in categories {
            // If the category isn't in the grouping dictionary, then it doesn't have any expenses
            // and its total should be set to 0.
            guard let expenses = groups?[category]
                else {
                    info.append((category, NSDecimalNumber(integer: 0), 0.0))
                    continue
            }
            
            let categoryTotal = glb_totalOfExpenses(expenses)
            let categoryPercent = categoryTotal.decimalNumberByDividingBy(overallTotal).doubleValue
            info.append((category, categoryTotal, categoryPercent))
        }
        
        info.sortInPlace({ $0.2 > $1.2 })
        
        return info
    }
    
}
