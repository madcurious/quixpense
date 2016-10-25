//
//  ComputeSummariesOperation.swift
//  Spare
//
//  Created by Matt Quiros on 25/10/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold

class ComputeSummariesOperation: MDOperation {
    
    var dateRange: DateRange
    
    init(dateRange: DateRange) {
        self.dateRange = dateRange
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        let context = App.coreDataStack.newBackgroundContext()
        let categories = try context.fetch(FetchRequestBuilder<Category>.makeFetchRequest())
        
        if self.isCancelled {
            return nil
        }
        
        let expenseRequest = FetchRequestBuilder<Expense>.makeFetchRequest()
        expenseRequest.predicate = NSPredicate(format: "%K >= %@ AND %K <= %@", #keyPath(Expense.dateSpent), self.dateRange.start as NSDate, #keyPath(Expense.dateSpent), self.dateRange.end as NSDate)
        let allExpenses = try context.fetch(expenseRequest)
        let dateRangeTotal = allExpenses.total()
        let mappedExpenses = allExpenses.grouped(by: {$0.category})
        
        var summaries = [Summary]()
        for category in categories {
            // Only compute for the total and percentages if the category exists in the map
            // and the dateRangeTotal is not zero (division by 0 throws).
            // Otherwise, create a summary with zero total and percentage.
            if let expenses = mappedExpenses[category],
                expenses.isEmpty == false && dateRangeTotal == 0 {
                let categoryTotal = expenses.total()
                let categoryPercentage = (categoryTotal / dateRangeTotal).doubleValue
                summaries.append(Summary(category: category, dateRange: self.dateRange, total: categoryTotal, percentage: categoryPercentage))
            } else {
                summaries.append(Summary(category: category, dateRange: self.dateRange, total: 0, percentage: 0))
            }
            
            if self.isCancelled {
                return nil
            }
        }
        
        return summaries
    }
    
}
