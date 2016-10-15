//
//  GetExpensesOperation.swift
//  Spare
//
//  Created by Matt Quiros on 19/09/2016.
//  Copyright © 2016 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

class GetExpensesOperation: MDOperation {
    
    var category: Category
    var startDate: Date
    var endDate: Date
    
    init(category: Category, startDate: Date, endDate: Date) {
        self.category = category
        self.startDate = startDate
        self.endDate = endDate
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        // Experimenting here. Notice how I use the main queue context for fetching the expenses.
        // I'm assuming that if you're just reading data and you're sure you won't have simultaneous operations writing to the store,
        // using the main context is OK; that a private queue is only necessary if writing changes at all.
        
        let request1 = FetchRequestBuilder<Expense>.makeFetchRequest()
        request1.predicate = NSPredicate(format: "category == %@ AND dateSpent >= %@ AND dateSpent <= %@", self.category, self.startDate as NSDate, self.endDate as NSDate)
        
        let request2 = FetchRequestBuilder<Expense>.makeFetchRequest()
        request2.predicate = NSPredicate(format: "dateSpent >= %@ AND dateSpent <= %@", [self.startDate, self.endDate])
        
        guard let allExpensesInCategory = try? App.mainQueueContext.fetch(request1),
            let allExpensesInDateRange = try? App.mainQueueContext.fetch(request2)
            else {
                return nil
        }
        
        let totalForCategory = allExpensesInCategory.total()
        let totalForDateRange = allExpensesInDateRange.total()
        let percent = (totalForCategory / totalForDateRange).doubleValue
        return (allExpensesInCategory, totalForCategory, percent)
    }
    
}
