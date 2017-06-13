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
        
        do {
            try self.context.saveToStore()
        } catch {
            print((error as NSError).userInfo)
            throw error
        }
        
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
            let expenseFetch = NSFetchRequest<Expense>(entityName: md_getClassName(Expense.self))
            var expenses = try! self.context.fetch(expenseFetch)
            if expenses.count == 0 {
                var components = DateComponents()
                components.month = 1
                components.day = 1
                components.year = 2017
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
        let categoryFetch = NSFetchRequest<Category>(entityName: md_getClassName(Category.self))
        let categories = try! self.context.fetch(categoryFetch)
        var dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)!
        
        print("fromDate: \(lastDate)")
        print("toDate: \(toDate)")
        print("Making dummy expenses for \(numberOfDays) days...")
        print("===============")
        
        for i in 0 ..< numberOfDays {
            print("Current date (day \(i + 1)): \(dateSpent)")
            
            var expenses = [Expense]()
            
            for category in categories {
                // Make 0-10 expenses.
                let numberOfExpenses = arc4random_uniform(10)
                print("- Making \(numberOfExpenses) expenses for category '\(category.name!)'")
                
                if numberOfExpenses == 0 {
                    // Avoid making section entities if there will be no expenses to begin with.
                    continue
                }
                
                var categorySectionTotal = 0.0
                
                for _ in 0 ..< numberOfExpenses {
                    let amount = 1 + (2500 * Double(arc4random()) / Double(UInt32.max))
                    categorySectionTotal += amount
                    
                    let newExpense = Expense(context: self.context)
                    newExpense.category = category
                    newExpense.amount = NSDecimalNumber(value: amount)
                    newExpense.dateSpent = dateSpent as NSDate
                    newExpense.dateCreated = Date() as NSDate
                    expenses.append(newExpense)
                    
                    print("-- amount: \(amount)")
                }
                
                self.makeDayCategoryGroup(for: expenses)
                self.makeWeekCategoryGroups(for: expenses)
                self.makeMonthCategoryGroups(for: expenses)
                expenses = []
            }
            
            dateSpent = Calendar.current.date(byAdding: .day, value: 1, to: dateSpent)!
        }
    }
    
    func makeDayCategoryGroup(for expenses: [Expense]) {
        let category = expenses.first!.category
        let total = expenses.total()
        let startDate = (expenses.first!.dateSpent! as Date).startOfDay()
        let endDate = startDate.endOfDay()
        
        let dayCategoryGroup = DayCategoryGroup(context: self.context)
        dayCategoryGroup.classifier = category
        dayCategoryGroup.total = total
        dayCategoryGroup.startDate = startDate as NSDate
        dayCategoryGroup.endDate = endDate as NSDate
        dayCategoryGroup.sectionIdentifier = SectionIdentifier.make(startDate: startDate, endDate: endDate)
        
        for expense in expenses {
            expense.dayCategoryGroup = dayCategoryGroup
        }
    }
    
    func makeWeekCategoryGroups(for expenses: [Expense]) {
        for expense in expenses {
            let firstWeekday = NSLocale.current.calendar.firstWeekday
            let weekStart = (expense.dateSpent! as Date).startOfWeek(firstWeekday: firstWeekday)
            let weekEnd = weekStart.endOfWeek(firstWeekday: firstWeekday)
            
            let fetchRequest = NSFetchRequest<WeekCategoryGroup>(entityName: md_getClassName(WeekCategoryGroup.self))
            fetchRequest.predicate = NSPredicate(format: "%@ == %@ AND %@ == %@ AND %@ == %@",
                                                 argumentArray: [
                                                    "startDate", weekStart,
                                                    "endDate", weekEnd,
                                                    "classifier", expense.category!
                ])
            if let existingGroup = try! self.context.fetch(fetchRequest).first,
                let runningTotal = existingGroup.value(forKey: "total") as? NSDecimalNumber {
                existingGroup.total = runningTotal.adding(expense.amount!)
                expense.weekCategoryGroup = existingGroup
            } else {
                let newGroup = WeekCategoryGroup(context: self.context)
                newGroup.startDate = weekStart as NSDate
                newGroup.endDate = weekEnd as NSDate
                newGroup.total = expense.amount
                newGroup.classifier = expense.category
                newGroup.sectionIdentifier = SectionIdentifier.make(startDate: weekStart, endDate: weekEnd)
                
                expense.weekCategoryGroup = newGroup
            }
        }
    }
    
    func makeMonthCategoryGroups(for expenses: [Expense]) {
        for expense in expenses {
            let startOfMonth = (expense.dateSpent! as Date).startOfMonth()
            let endOfMonth = (expense.dateSpent! as Date).endOfMonth()
            let fetchRequest = NSFetchRequest<MonthCategoryGroup>(entityName: md_getClassName(MonthCategoryGroup.self))
            fetchRequest.predicate = NSPredicate(format: "%@ == %@ AND %@ == %@ AND %@ == %@",
                                                 argumentArray: [
                                                    "startDate", startOfMonth,
                                                    "endDate", endOfMonth,
                                                    "classifier", expense.category!
                ])
            if let existingGroup = try! self.context.fetch(fetchRequest).first,
                let runningTotal = existingGroup.value(forKey: "total") as? NSDecimalNumber {
                existingGroup.total = runningTotal.adding(expense.amount!)
                expense.monthCategoryGroup = existingGroup
            } else {
                let newGroup = MonthCategoryGroup(context: self.context)
                newGroup.startDate = startOfMonth as NSDate
                newGroup.endDate = endOfMonth as NSDate
                newGroup.total = expense.amount
                newGroup.classifier = expense.category
                newGroup.sectionIdentifier = SectionIdentifier.make(startDate: startOfMonth, endDate: endOfMonth)
                
                expense.monthCategoryGroup = newGroup
            }
        }
    }
    
    deinit {
        print("Deinit \(self)")
    }
    
}
