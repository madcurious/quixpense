//
//  MakeDummyDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 22/02/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import CoreData
import Mold

private let kCategoryNames = [
    "Food and Drinks",
    "Transportation",
    "Grooming",
    "Fitness",
    "Electronics",
    "Vacation"
]

class MakeDummyDataOperation: MDOperation<Any?> {
    
    var context: NSManagedObjectContext!
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
        self.makeCategories()
        self.makeExpenses()
        try self.context.saveToStore()
        
        return nil
    }
    
    func makeCategories() {
        let categoryFetch = NSFetchRequest<Category>(entityName: "Category")
        let categories = try! self.context.fetch(categoryFetch)
        
        // Don't make categories if there already are.
        guard categories.count == 0
            else {
                return
        }

        for categoryName in kCategoryNames {
            let category = Category(context: self.context)
            category.name = categoryName
        }
    }
    
    func makeExpenses() {
        let lastDate: Date = {
            let expenseFetch = NSFetchRequest<Expense>(entityName: "Expense")
            var expenses = try! self.context.fetch(expenseFetch)
            if expenses.count == 0 {
                var components = DateComponents()
                components.month = 1
                components.day = 1
                components.year = 2016
                let fromDate = Calendar.current.date(from: components)!
                return fromDate
            } else {
                expenses.sort(by: { $0.dateSpent!.compare($1.dateSpent! as Date) == .orderedAscending })
                let fromDate = expenses.last!.dateSpent! as Date
                return fromDate
            }
        }()
        
        let toDate = Date()
        
        if lastDate.isSameDayAsDate(toDate) {
            print("From and to date are the same, not making any new expenses.")
            return
        }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: lastDate, to: toDate).day!
        let categoryFetch = NSFetchRequest<Category>(entityName: "Category")
        let categories = try! self.context.fetch(categoryFetch)
        var dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
        
        print("fromDate: \(lastDate)")
        print("toDate: \(toDate)")
        print("Making dummy expenses for \(numberOfDays) days...")
        print("===============")
        
        for i in 0 ..< numberOfDays {
            print("Current date (day \(i + 1)): \(dateSpent)")
            for category in categories {
                // Make 0-10 expenses.
                let numberOfExpenses = arc4random_uniform(10)
                print("- Making \(numberOfExpenses) expenses for category '\(category.name!)'")
                
                for _ in 0 ..< numberOfExpenses {
                    // Generate amount from 1-3000 pesos.
                    let amount = 1 + (2500 * Double(arc4random()) / Double(UInt32.max))
                    
                    let newExpense = Expense(context: self.context)
                    newExpense.category = category
                    newExpense.amount = NSDecimalNumber(value: amount)
                    newExpense.dateSpent = dateSpent as NSDate
                    
                    print("-- amount: \(amount)")
                }
            }
            
            dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: dateSpent)!
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
