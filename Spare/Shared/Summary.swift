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
        do {
            let request = NSFetchRequest(entityName: Expense.entityName)
            request.predicate = NSPredicate(format: "dateSpent >= %@ AND dateSpent <= %@", self.startDate, self.endDate)
            if let expenses = try App.state.mainQueueContext.executeFetchRequest(request) as? [Expense]
                where expenses.isEmpty == false {
                return expenses
            }
        } catch {}
        return nil
    }
    
    /**
     Returns the total of all the expenses in this date range.
     */
    var total: NSDecimalNumber {
        guard let expenses = self.expenses
            else {
                return NSDecimalNumber(integer: 0)
        }
        
        return expenses.map({ $0.amount ?? NSDecimalNumber(integer: 0)}).reduce(0, combine: +)
    }
    
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
            
            let categoryTotal = expenses.map({ $0.amount ?? NSDecimalNumber(integer: 0) }).reduce(0, combine: +)
            let categoryPercent = categoryTotal.decimalNumberByDividingBy(overallTotal).doubleValue
            info.append((category, categoryTotal, categoryPercent))
        }
        
        info.sortInPlace({ $0.1.compare($1.1) == .OrderedAscending })
        
        return info
    }
    
    var dateRangeDisplayText: String {
        switch self.periodization {
        case .Day:
            if self.startDate.isSameDayAsDate(NSDate()) {
                return "Today"
            } else {
                return Summary.dateFormatter.stringFromDate(self.startDate)
            }
            
        default:
            fatalError("Unimplemented")
        }
    }
    
}
