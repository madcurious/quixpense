//
//  MakeDefaultDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 27/03/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

class MakeDefaultDataOperation: MDOperation {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        self.makeDefaultCategories()
        self.makeDefaultExpenseFilters()
        
        try self.context.saveToStore()
        
        return nil
    }
    
    private func makeDefaultCategories() {
        let uncategorized = Category(context: self.context)
        uncategorized.name = "Uncategorized"
    }
    
    private func makeDefaultExpenseFilters() {
        let expenseFilters = [("All Expenses", false),
                              ("Last 7 days", true),
                              ("Last 30 days", true)]
        
        for i in 0 ..< expenseFilters.count {
            let filter = ExpenseFilter(context: self.context)
            filter.name = expenseFilters[i].0
            filter.isUserEditable = expenseFilters[i].1
            filter.displayOrder = Double(i + 1)
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
