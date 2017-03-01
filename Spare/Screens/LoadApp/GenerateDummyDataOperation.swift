//
//  GenerateDummyDataOperation.swift
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

class GenerateDummyDataOperation: MDOperation {
    
    var context: NSManagedObjectContext!
    
    override var shouldExecute: Bool {
        guard let coreDataStack = Global.coreDataStack
            else {
                return false
        }
        
        let context = coreDataStack.newBackgroundContext()
        let categoryFetch = NSFetchRequest<Category>(entityName: "Category")
        let categories = try! context.fetch(categoryFetch)
        if categories.count == 0 {
            return true
        }
        
        return false
    }
    
    override func makeResult(from source: Any?) throws -> Any? {
        self.context = Global.coreDataStack.newBackgroundContext()
        
//        // DEBUG
//        let request: NSFetchRequest<Category> = Category.fetchRequest()
//        context.performAndWait {
//            let categories = try! request.execute()
//            for category in categories {
//                print(category.name!)
//            }
//        }
        
        self.makeCategories()
        self.makeExpenses()
        
        try self.context.saveToStore()
        
        return nil
    }
    
    func makeCategories() {
        for categoryName in kCategoryNames {
            let category = Category(context: context)
            category.name = categoryName
        }
    }
    
    func makeExpenses() {
        let fromDate: Date = {
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
                expenses.sort(by: { $0.dateSpent!.compare($1.dateSpent! as Date) == .orderedDescending })
                let fromDate = expenses.first!.dateSpent! as Date
                return fromDate
            }
        }()
        
        let toDate = Date()
        
        if (fromDate as Date).isSameDayAsDate(toDate) {
            return
        }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
        let categoryFetch = NSFetchRequest<Category>(entityName: "Category")
        let categories = try! self.context.fetch(categoryFetch)
        var dateSpent = fromDate
        
        print("Making dummy expenses for \(numberOfDays) days...")
        
        for i in 0 ..< numberOfDays {
            print("Current date (day \(i + 1)): \(dateSpent)")
            for category in categories {
                // Make 1-20 expenses.
                let numberOfExpenses = 1 + arc4random_uniform(20)
                print("- Making \(numberOfExpenses) expenses for category '\(category.name!)'")
                
                for _ in 0 ..< numberOfExpenses {
                    // Generate amount from 1-3000 pesos.
                    let amount = 1 + (3000 * Double(arc4random()) / Double(arc4random_uniform(UInt32.max)))
                    
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
