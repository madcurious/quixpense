//
//  MakeDummyDataOperation.swift
//  Spare
//
//  Created by Matt Quiros on 16/01/2017.
//  Copyright © 2017 Matt Quiros. All rights reserved.
//

import Foundation
import Mold
import CoreData

class MakeDummyDataOperation: MDOperation {
    
    let oldestYear = 2013
    
    override init() {
        
    }
    
    override func makeResult(fromSource source: Any?) throws -> Any? {
        let mainContext = App.mainQueueContext
        let writeContext = App.coreDataStack.newBackgroundContext()
        
        // If there are no categories yet, make them.
        
        let categoryFetch = FetchRequestBuilder<Category>.makeIDOnlyRequest()
        let allCategories = try mainContext.fetch(categoryFetch)
        if allCategories.count == 0 {
            self.makeCategories(inContext: writeContext)
        }
        
        // If there are no expenses yet, create expenses from 2013 to the current date.
        // Otherwise, get the oldest recorded expense, and make expenses from that date to the current date.
        
        let expenseFetch = FetchRequestBuilder<Expense>.makeTypedRequest()
        expenseFetch.sortDescriptors = [NSSortDescriptor(key: "dateSpent", ascending: false)]
        let expenses = try mainContext.fetch(expenseFetch)
        let oldestDate: Date
        
        if expenses.count == 0 {
            var dateComponents = DateComponents()
            dateComponents.month = 1
            dateComponents.day = 1
            dateComponents.year = self.oldestYear
            oldestDate = Calendar.current.date(from: dateComponents)!.startOfDay()
        } else {
            oldestDate = Calendar.current.date(byAdding: .day, value: 1, to: expenses.first!.dateSpent! as Date)!.startOfDay()
        }
        
        self.makeExpenses(fromDate: oldestDate, inContext: writeContext)
        writeContext.performAndWait { 
            writeContext.saveRecursively(nil)
        }
        
        return nil
    }
    
    func makeCategories(inContext context: NSManagedObjectContext) {
        let categoryNames = [
            "Food and Drinks",
            "Transportation",
            "Utility Bills",
            "Clothing",
            "Medical Expenses and Health Care",
            "Gadgets",
            "Repairs",
            "Leisure",
            "Gifts and Treats",
            "Charity"
        ]
        
        for categoryName in categoryNames {
            let newCategory = Category(context: context)
            newCategory.name = categoryName
        }
    }
    
    func makeExpenses(fromDate date: Date, inContext context: NSManagedObjectContext) {
        let currentDate = Date()
        if date.isSameDayAsDate(currentDate) {
            return
        }
        
        let difference = Calendar.current.dateComponents([.day], from: date, to: currentDate)
        let numberOfDays = difference.day!
        
        let categoryFetch = FetchRequestBuilder<Category>.makeTypedRequest()
        let categories = try! context.fetch(categoryFetch)
        
        var dateSpent = date.startOfDay()
        
        for category in categories {
            for _ in 0 ..< numberOfDays {
                // Make 1-20 expenses.
                let numberOfExpenses = 1 + arc4random_uniform(20)
                
                for _ in 0 ..< numberOfExpenses {
                    // Generate amount from 10-3010 pesos.
                    let amount = 10 + (3000 * Double(arc4random()) / Double(arc4random_uniform(UInt32.max)))
                    let paymentMethod = 1 + arc4random_uniform(3)
                    
                    let newExpense = Expense(context: context)
                    newExpense.category = category
                    newExpense.amount = NSDecimalNumber(value: amount)
                    newExpense.dateSpent = dateSpent as NSDate
                    newExpense.paymentMethod = NSNumber(value: paymentMethod)
                }
                
                dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: dateSpent)!
            }
        }
    }
    
}
